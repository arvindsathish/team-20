/* T20 Role Patrol - Operational & Gateway Procedures
   Greenfield Version for Hackathon Team 20.
   Full varchar(16) support for employee IDs. */
SET NOCOUNT ON;
GO

CREATE OR ALTER PROCEDURE core.usp_GroupMap 
AS
BEGIN 
    SET NOCOUNT ON; 
    SELECT EntitlementId, ObjectId FROM src.GroupMap ORDER BY EntitlementId; 
END;
GO

CREATE OR ALTER PROCEDURE core.usp_Ingest 
AS
BEGIN
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    IF (SELECT COUNT(*) FROM src.Employee) = 0 
       OR (SELECT COUNT(*) FROM src.Role) = 0 
       OR (SELECT COUNT(*) FROM src.RoleVersion) = 0 
       OR (SELECT COUNT(*) FROM src.Ticket) = 0 
        THROW 51000, 'Source batch is empty or missing required entities', 1;

    IF EXISTS (
        SELECT 1 FROM src.Ticket t 
        LEFT JOIN src.Ticket r ON r.TicketId = t.CanonicalRoot 
        WHERE r.TicketId IS NULL OR t.EmployeeId <> r.EmployeeId
    ) 
        THROW 51000, 'Invalid ticket canonical root', 1;

    UPDATE src.SourceStatus SET CheckedAt = SYSUTCDATETIME() WHERE Complete = 1;
    SELECT 'Synthetic SQL sources validated dynamically; snapshot ingestion runs in usp_Assess' AS Validation;
END;
GO

CREATE OR ALTER PROCEDURE core.usp_SearchQueue 
AS
BEGIN
    SET NOCOUNT ON;
    SELECT t.TicketId, t.TicketText 
    FROM src.Ticket t 
    WHERE t.TicketType LIKE '%Access%' 
      AND t.EntitlementId IS NULL 
      AND NOT EXISTS (
          SELECT 1 FROM core.MatchCandidate c 
          WHERE c.TicketId = t.TicketId AND c.Status = 'Confirmed'
      );
END;
GO

CREATE OR ALTER PROCEDURE core.usp_StoreCandidate 
    @TicketId varchar(16),
    @EntitlementId varchar(24),
    @Relevance float = NULL
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM src.Ticket WHERE TicketId = @TicketId AND EntitlementId IS NULL) 
       OR NOT EXISTS (SELECT 1 FROM src.Entitlement WHERE EntitlementId = @EntitlementId) 
        THROW 51000, 'Invalid candidate', 1;

    IF NOT EXISTS (SELECT 1 FROM core.MatchCandidate WHERE TicketId = @TicketId AND EntitlementId = @EntitlementId)
        INSERT INTO core.MatchCandidate (TicketId, EntitlementId, Relevance, Status) 
        VALUES (@TicketId, @EntitlementId, @Relevance, 'Candidate');
END;
GO

CREATE OR ALTER PROCEDURE api.usp_Matches 
    @Payload nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    DECLARE @actor varchar(16) = (SELECT EmployeeId FROM core.Principal WHERE DbUser = USER_NAME()),
            @op varchar(20) = JSON_VALUE(@Payload, '$.op'),
            @candidate int = TRY_CONVERT(int, JSON_VALUE(@Payload, '$.candidateId')),
            @decision varchar(16) = JSON_VALUE(@Payload, '$.matchDecision');

    IF @actor IS NULL THROW 51003, 'Caller not mapped', 1;

    SELECT c.CandidateId, c.TicketId, c.EntitlementId, c.Relevance, c.Status, t.TicketText, v.RoleId 
    INTO #scoped
    FROM core.MatchCandidate c 
    JOIN src.Ticket t ON t.TicketId = c.TicketId
    CROSS APPLY (
        SELECT TOP(1) a.VersionId 
        FROM src.Assignment a 
        WHERE a.EmployeeId = t.EmployeeId 
          AND a.ValidFrom <= t.OpenedAt 
          AND (a.ValidTo IS NULL OR a.ValidTo > t.OpenedAt) 
        ORDER BY a.ValidFrom DESC
    ) a
    JOIN src.RoleVersion v ON v.VersionId = a.VersionId
    JOIN core.Permission p ON p.EmployeeId = @actor AND p.RoleId = v.RoleId AND p.CanIam = 1;

    IF @op = 'matches' 
    BEGIN 
        SELECT 200 AS HttpStatus, (SELECT * FROM #scoped ORDER BY TicketId, CandidateId FOR JSON PATH) AS ResponseJson; 
        RETURN; 
    END;

    IF @decision NOT IN ('Confirmed', 'Rejected') 
       OR NOT EXISTS (SELECT 1 FROM #scoped WHERE CandidateId = @candidate AND Status = 'Candidate') 
        THROW 51003, 'Candidate is outside IAM scope or no longer pending', 1;

    BEGIN TRAN;
    DECLARE @ticket varchar(16) = (SELECT TicketId FROM #scoped WHERE CandidateId = @candidate);
    IF @decision = 'Confirmed' AND EXISTS (SELECT 1 FROM core.MatchCandidate WITH (UPDLOCK, HOLDLOCK) WHERE TicketId = @ticket AND Status = 'Confirmed') 
    BEGIN 
        ROLLBACK; 
        THROW 51009, 'Ticket already has a confirmed match', 1; 
    END;

    UPDATE core.MatchCandidate 
    SET Status = @decision, ConfirmedBy = @actor, ConfirmedAt = SYSUTCDATETIME() 
    WHERE CandidateId = @candidate AND Status = 'Candidate';

    INSERT INTO audit.Event (Actor, ActionName, ObjectId, Detail) 
    VALUES (@actor, 'TicketMatch', @ticket, @decision);

    COMMIT;
    SELECT 200 AS HttpStatus, N'{"message":"Match decision recorded. Run a new assessment to use it; historical snapshots unchanged."}' AS ResponseJson;
END;
GO

CREATE OR ALTER PROCEDURE api.usp_Gateway 
    @Payload nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF ISJSON(@Payload) <> 1 OR DATALENGTH(@Payload) > 32000 
            THROW 51000, 'Invalid request', 1;

        DECLARE @op varchar(20) = JSON_VALUE(@Payload, '$.op');
        IF @op IN ('overview', 'role', 'history', 'worklist') EXEC api.usp_Read @Payload;
        ELSE IF @op = 'decide' EXEC api.usp_Decide @Payload;
        ELSE IF @op = 'scenario' EXEC api.usp_Scenario @Payload;
        ELSE IF @op = 'iam' EXEC api.usp_Iam @Payload;
        ELSE IF @op IN ('matches', 'match') EXEC api.usp_Matches @Payload;
        ELSE THROW 51000, 'Unsupported operation', 1;
    END TRY 
    BEGIN CATCH
        DECLARE @status int = CASE ERROR_NUMBER() 
            WHEN 51003 THEN 403 
            WHEN 51004 THEN 404 
            WHEN 51009 THEN 409 
            WHEN 51000 THEN 400 
            ELSE 500 
        END;
        SELECT @status AS HttpStatus, (
            SELECT CASE @status 
                WHEN 403 THEN 'Access denied' 
                WHEN 404 THEN 'Not found' 
                WHEN 409 THEN 'Stale evidence or conflicting request; reload' 
                WHEN 400 THEN ERROR_MESSAGE() 
                ELSE 'Backend failed; consult protected run history' 
            END AS error 
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        ) AS ResponseJson;
    END CATCH;
END;
GO

CREATE OR ALTER VIEW core.vw_ImpactReporting AS 
SELECT a.BusinessAsOf, a.CompletedAt, a.RuleVersion, i.* 
FROM core.Impact i 
JOIN core.Assessment a ON a.RunId = i.RunId 
WHERE a.Status = 'Complete';
GO

CREATE OR ALTER VIEW core.vw_Catalog AS 
SELECT EntitlementId, DisplayName, Risk, ContextCode 
FROM src.Entitlement;
GO

SELECT 'Operations and Gateway Procedures for Team20 installed successfully.' AS Result;
GO
