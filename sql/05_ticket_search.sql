/* T20 Role Patrol - Bounded Ticket-Topic Search
   Greenfield Version for Hackathon Team 20.
   Full varchar(16) employee and actor ID support. */
SET NOCOUNT ON;
GO

IF SCHEMA_ID('search') IS NULL EXEC('CREATE SCHEMA search');
GO

CREATE OR ALTER VIEW search.vTicketDocument
AS
    SELECT TicketId, TicketText, ContextCode, TicketType
    FROM src.Ticket
    WHERE TicketType LIKE '%Access%';
GO

IF OBJECT_ID('core.TicketSearchSession', 'U') IS NULL
CREATE TABLE core.TicketSearchSession(
    SearchId uniqueidentifier NOT NULL PRIMARY KEY,
    QueryText nvarchar(240) NOT NULL,
    GroupBy varchar(8) NOT NULL CHECK (GroupBy IN ('Role', 'Region')),
    RegionFilter varchar(3) NULL,
    SearchMode varchar(16) NOT NULL CHECK (SearchMode IN ('Semantic', 'Lexical')),
    Actor varchar(16) NOT NULL,
    CreatedAt datetime2 NOT NULL DEFAULT SYSUTCDATETIME()
);
GO

IF OBJECT_ID('core.TicketSearchCandidate', 'U') IS NULL
CREATE TABLE core.TicketSearchCandidate(
    CandidateId bigint IDENTITY(1,1) NOT NULL PRIMARY KEY,
    SearchId uniqueidentifier NOT NULL REFERENCES core.TicketSearchSession(SearchId),
    TicketId varchar(16) NOT NULL REFERENCES src.Ticket(TicketId),
    SearchRelevance float NULL,
    SearchRank int NOT NULL,
    Status varchar(12) NOT NULL CHECK (Status IN ('Candidate', 'Confirmed', 'Rejected')),
    ConfirmedBy varchar(16) NULL,
    ConfirmedAt datetime2 NULL,
    CONSTRAINT UQ_TicketSearchCandidate UNIQUE (SearchId, TicketId)
);
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'IX_TicketSearchCandidate_SessionStatus')
    CREATE INDEX IX_TicketSearchCandidate_SessionStatus ON core.TicketSearchCandidate(SearchId, Status, SearchRank);
GO

CREATE OR ALTER PROCEDURE api.usp_TicketSearch 
    @Payload nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @actor varchar(16) = (SELECT EmployeeId FROM core.Principal WHERE DbUser = USER_NAME()),
            @action varchar(16) = COALESCE(JSON_VALUE(@Payload, '$.searchAction'), 'Search'),
            @searchId uniqueidentifier = TRY_CONVERT(uniqueidentifier, JSON_VALUE(@Payload, '$.searchId')),
            @candidateId bigint = TRY_CONVERT(bigint, JSON_VALUE(@Payload, '$.candidateId')),
            @decision varchar(12) = JSON_VALUE(@Payload, '$.decision'),
            @query nvarchar(240) = NULLIF(LTRIM(RTRIM(JSON_VALUE(@Payload, '$.query'))), ''),
            @groupBy varchar(8) = COALESCE(JSON_VALUE(@Payload, '$.groupBy'), 'Role'),
            @region varchar(3) = NULLIF(JSON_VALUE(@Payload, '$.region'), 'All'),
            @mode varchar(16) = COALESCE(JSON_VALUE(@Payload, '$.searchMode'), 'Lexical'),
            @result nvarchar(max), 
            @asOf datetime2;

    IF @actor IS NULL THROW 51003, 'Caller not mapped', 1;
    IF @action NOT IN ('Search', 'Refresh', 'Decision') THROW 51000, 'Unsupported ticket search action', 1;

    IF @action = 'Search'
    BEGIN
        IF @query IS NULL OR LEN(@query) > 240 OR @groupBy NOT IN ('Role', 'Region') OR @mode NOT IN ('Semantic', 'Lexical')
            THROW 51000, 'Query, groupBy, or searchMode is invalid', 1;
        IF ISJSON(JSON_QUERY(@Payload, '$.searchResponse')) <> 1 
            THROW 51000, 'Search candidates are required', 1;
        IF (SELECT COUNT(*) FROM OPENJSON(@Payload, '$.searchResponse')) > 20 
            THROW 51000, 'Search returned too many candidates', 1;

        SET @searchId = NEWID();
        SELECT @asOf = a.BusinessAsOf 
        FROM core.Published p 
        JOIN core.Assessment a ON a.RunId = p.RunId 
        WHERE p.StreamId = 1 AND a.Status = 'Complete';

        IF @asOf IS NULL THROW 51004, 'No completed assessment is available', 1;

        INSERT INTO core.TicketSearchSession (SearchId, QueryText, GroupBy, RegionFilter, SearchMode, Actor)
        VALUES (@searchId, @query, @groupBy, @region, @mode, @actor);

        ;WITH hits AS (
            SELECT CONVERT(varchar(16), JSON_VALUE(j.value, '$.ticketId')) AS TicketId,
                   TRY_CONVERT(float, JSON_VALUE(j.value, '$."@search.score"')) AS SearchRelevance,
                   TRY_CONVERT(int, j.[key]) + 1 AS SearchRank
            FROM OPENJSON(@Payload, '$.searchResponse') j
        )
        INSERT INTO core.TicketSearchCandidate (SearchId, TicketId, SearchRelevance, SearchRank, Status)
        SELECT @searchId, h.TicketId, h.SearchRelevance, COALESCE(h.SearchRank, 1), 'Candidate'
        FROM hits h
        JOIN src.Ticket t ON t.TicketId = h.TicketId
        WHERE NOT EXISTS (SELECT 1 FROM core.TicketSearchCandidate c WHERE c.SearchId = @searchId AND c.TicketId = h.TicketId);
    END;

    IF @action = 'Decision'
    BEGIN
        IF @searchId IS NULL OR @candidateId IS NULL OR @decision NOT IN ('Confirmed', 'Rejected') 
            THROW 51000, 'Decision payload is invalid', 1;

        BEGIN TRAN;
        IF NOT EXISTS (
            SELECT 1 FROM core.TicketSearchCandidate c
            JOIN core.TicketSearchSession s ON s.SearchId = c.SearchId
            JOIN src.Ticket t ON t.TicketId = c.TicketId
            CROSS APPLY (
                SELECT TOP(1) m.ToVersion 
                FROM src.Move m 
                WHERE m.EmployeeId = t.EmployeeId AND m.EffectiveAt <= t.OpenedAt 
                ORDER BY m.EffectiveAt DESC, m.EventId DESC
            ) m
            JOIN src.RoleVersion v ON v.VersionId = m.ToVersion
            JOIN core.Permission p ON p.EmployeeId = @actor AND p.RoleId = v.RoleId AND p.CanIam = 1
            WHERE c.SearchId = @searchId AND c.CandidateId = @candidateId AND c.Status = 'Candidate'
        ) 
            THROW 51003, 'Candidate is outside IAM scope or no longer pending', 1;

        UPDATE core.TicketSearchCandidate 
        SET Status = @decision, ConfirmedBy = @actor, ConfirmedAt = SYSUTCDATETIME()
        WHERE SearchId = @searchId AND CandidateId = @candidateId AND Status = 'Candidate';

        INSERT INTO audit.Event (Actor, ActionName, ObjectId, Detail)
        VALUES (@actor, 'TicketTopicMatch', CONVERT(nvarchar(36), @searchId), CONCAT(@decision, ' candidate ', @candidateId));

        COMMIT;
    END;

    IF @searchId IS NULL OR NOT EXISTS (
        SELECT 1 FROM core.TicketSearchSession s 
        WHERE s.SearchId = @searchId 
          AND (s.Actor = @actor OR EXISTS (
              SELECT 1 FROM core.TicketSearchCandidate c
              JOIN src.Ticket t ON t.TicketId = c.TicketId
              CROSS APPLY (
                  SELECT TOP(1) m.ToVersion 
                  FROM src.Move m 
                  WHERE m.EmployeeId = t.EmployeeId AND m.EffectiveAt <= t.OpenedAt 
                  ORDER BY m.EffectiveAt DESC, m.EventId DESC
              ) m
              JOIN src.RoleVersion v ON v.VersionId = m.ToVersion
              JOIN core.Permission p ON p.EmployeeId = @actor AND p.RoleId = v.RoleId AND p.CanReadDetail = 1
              WHERE c.SearchId = s.SearchId
          ))
    )
        THROW 51003, 'Search session is outside caller scope', 1;

    SELECT @asOf = a.BusinessAsOf 
    FROM core.Published p 
    JOIN core.Assessment a ON a.RunId = p.RunId 
    WHERE p.StreamId = 1 AND a.Status = 'Complete';

    DECLARE @groups nvarchar(max), @candidates nvarchar(max), @summary nvarchar(max);
    ;WITH candidate_roles AS (
        SELECT c.Status, c.CandidateId, c.SearchRelevance, c.SearchRank, t.TicketId, t.EmployeeId,
               COALESCE(NULLIF(t.CanonicalRoot, ''), t.TicketId) AS CanonicalTicket,
               COALESCE(v.RoleId, re.RoleId, 'General') AS RoleId,
               COALESCE(r.JobTitle, re.JobTitle, 'Access Request') AS JobTitle,
               COALESCE(r.Country, re.Country, 'US') AS Country,
               CASE 
                   WHEN m.EffectiveAt >= DATEADD(day, -90, @asOf) AND m.EffectiveAt <= DATEADD(day, -30, @asOf)
                    AND t.OpenedAt < DATEADD(day, 30, m.EffectiveAt)
                    AND NOT EXISTS (
                        SELECT 1 FROM src.Move x 
                        WHERE x.EmployeeId = t.EmployeeId AND x.EffectiveAt = m.EffectiveAt AND x.EventId <> m.EventId
                    )
                   THEN 1 ELSE 0 
               END AS IsAuditedMover
        FROM core.TicketSearchCandidate c
        JOIN core.TicketSearchSession s ON s.SearchId = c.SearchId
        JOIN src.Ticket t ON t.TicketId = c.TicketId
        OUTER APPLY (
            SELECT TOP(1) m.EventId, m.EffectiveAt, m.ToVersion 
            FROM src.Move m
            WHERE m.EmployeeId = t.EmployeeId AND m.EffectiveAt <= t.OpenedAt 
            ORDER BY m.EffectiveAt DESC, m.EventId DESC
        ) m
        LEFT JOIN src.RoleVersion v ON v.VersionId = m.ToVersion
        LEFT JOIN src.Role r ON r.RoleId = v.RoleId
        OUTER APPLY (
            SELECT TOP(1) r2.RoleId, r2.JobTitle, r2.Country
            FROM src.RoleEntitlement re2
            JOIN src.RoleVersion rv2 ON rv2.VersionId = re2.VersionId
            JOIN src.Role r2 ON r2.RoleId = rv2.RoleId
            WHERE re2.EntitlementId = t.EntitlementId
            ORDER BY r2.RoleId
        ) re
        WHERE c.SearchId = @searchId 
          AND (s.RegionFilter IS NULL OR COALESCE(r.Country, re.Country, 'US') = s.RegionFilter)
    ), 
    confirmed AS (
        SELECT * FROM candidate_roles WHERE Status = 'Confirmed'
    )
    SELECT @groups = (
        SELECT CASE WHEN @groupBy = 'Role' THEN x.RoleId ELSE x.Country END AS [group],
               CASE WHEN @groupBy = 'Role' THEN MAX(x.JobTitle) ELSE x.Country END AS label,
               COUNT(DISTINCT x.CanonicalTicket) AS confirmedTickets,
               COUNT(DISTINCT x.EmployeeId) AS affectedEmployees
        FROM confirmed x 
        GROUP BY CASE WHEN @groupBy = 'Role' THEN x.RoleId ELSE x.Country END, x.Country
        ORDER BY confirmedTickets DESC, [group] 
        FOR JSON PATH
    ),
    @candidates = (
        SELECT x.CandidateId, x.TicketId, t.TicketText, x.RoleId, x.JobTitle, x.Country,
               x.Status, x.SearchRank,
               IIF(x.IsAuditedMover = 1 AND EXISTS (SELECT 1 FROM core.Permission p WHERE p.EmployeeId = @actor AND p.RoleId = x.RoleId AND p.CanIam = 1), 1, 0) AS canConfirm
        FROM candidate_roles x 
        JOIN src.Ticket t ON t.TicketId = x.TicketId
        ORDER BY x.SearchRank, x.TicketId 
        FOR JSON PATH
    ),
    @summary = (
        SELECT s.SearchId, s.QueryText, s.GroupBy, s.RegionFilter, s.SearchMode, s.CreatedAt,
               COALESCE(SUM(IIF(x.Status = 'Confirmed', 1, 0)), 0) AS confirmedCandidateCount,
               COALESCE(SUM(IIF(x.Status = 'Candidate', 1, 0)), 0) AS pendingCandidateCount,
               COALESCE(SUM(IIF(x.Status = 'Rejected', 1, 0)), 0) AS rejectedCandidateCount
        FROM core.TicketSearchSession s 
        LEFT JOIN candidate_roles x ON 1 = 1
        WHERE s.SearchId = @searchId
        GROUP BY s.SearchId, s.QueryText, s.GroupBy, s.RegionFilter, s.SearchMode, s.CreatedAt
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    );

    SELECT 200 AS HttpStatus, (
        SELECT JSON_QUERY(COALESCE(@summary, N'{}')) AS search,
               JSON_QUERY(COALESCE(@groups, N'[]')) AS confirmedResults,
               JSON_QUERY(COALESCE(@candidates, N'[]')) AS candidates,
               N'Azure AI Search proposes ticket candidates. SQL reports only human-confirmed matches; this search does not change Role Patrol ranking.' AS notice
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    ) AS ResponseJson;
END;
GO

-- Update api.usp_Gateway to route ticketSearch
CREATE OR ALTER PROCEDURE api.usp_Gateway 
    @Payload nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        IF ISJSON(@Payload) <> 1 OR DATALENGTH(@Payload) > 32000 
            THROW 51000, 'Invalid request', 1;

        DECLARE @op varchar(24) = JSON_VALUE(@Payload, '$.op');
        IF @op IN ('ticketSearch', 'ticketSearchDecision')
        BEGIN
            IF @op = 'ticketSearchDecision' SET @Payload = JSON_MODIFY(@Payload, '$.searchAction', 'Decision');
            EXEC api.usp_TicketSearch @Payload;
        END
        ELSE IF @op IN ('overview', 'role', 'history', 'worklist') EXEC api.usp_Read @Payload;
        ELSE IF @op = 'decide' EXEC api.usp_Decide @Payload;
        ELSE IF @op = 'scenario' EXEC api.usp_Scenario @Payload;
        ELSE IF @op = 'iam' EXEC api.usp_Iam @Payload;
        ELSE IF @op IN ('matches', 'match') EXEC api.usp_Matches @Payload;
        ELSE THROW 51000, 'Unsupported operation', 1;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
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
                WHEN 409 THEN 'Conflict; reload the evidence' 
                WHEN 400 THEN ERROR_MESSAGE() 
                ELSE 'Backend failed; consult protected workflow run history' 
            END AS error 
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        ) AS ResponseJson;
    END CATCH;
END;
GO

SELECT 'Ticket Search Procedures for Team20 installed successfully.' AS Result;
GO
