/* T20 Role Patrol - Core Calculation Engine & API Gateway
   Greenfield Version for Hackathon Team 20.
   Full varchar(16) employee ID support.
   Dynamic validations (zero hardcoded mock counts). */
SET NOCOUNT ON;
GO

-- 1. Entra Group Member Collection Procedure
CREATE OR ALTER PROCEDURE core.usp_Collect 
    @Action varchar(16),
    @CollectionId uniqueidentifier,
    @EntitlementId varchar(24) = NULL,
    @PageJson nvarchar(max) = NULL,
    @LastPage bit = 0
AS
BEGIN
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    IF @Action = 'Start' 
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM core.Collection WHERE CollectionId = @CollectionId)
            INSERT INTO core.Collection (CollectionId, StartedAt, Mode, Status)
            VALUES (@CollectionId, SYSUTCDATETIME(), 'EntraLive', 'Building');
        RETURN;
    END;

    IF NOT EXISTS (SELECT 1 FROM core.Collection WHERE CollectionId = @CollectionId AND Status = 'Building') 
        THROW 51000, 'Collection is not writable', 1;

    IF @Action = 'Page' 
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM src.GroupMap WHERE EntitlementId = @EntitlementId) 
            THROW 51000, 'Group not allowlisted', 1;
        IF ISJSON(@PageJson) <> 1 
            THROW 51000, 'Invalid Graph page', 1;

        BEGIN TRAN;
        IF NOT EXISTS (SELECT 1 FROM core.CollectionGroup WHERE CollectionId = @CollectionId AND EntitlementId = @EntitlementId)
            INSERT INTO core.CollectionGroup (CollectionId, EntitlementId, Status, Pages)
            VALUES (@CollectionId, @EntitlementId, 'Building', 0);

        INSERT INTO core.Member (CollectionId, EmployeeId, EntitlementId)
        SELECT DISTINCT @CollectionId, i.EmployeeId, @EntitlementId 
        FROM OPENJSON(@PageJson, '$.value') WITH (
            ObjectId uniqueidentifier '$.id',
            ObjectType nvarchar(100) '$."@odata.type"'
        ) j
        JOIN src.IdentityMap i ON i.ObjectId = j.ObjectId
        WHERE j.ObjectType = '#microsoft.graph.user' 
          AND NOT EXISTS (
              SELECT 1 FROM core.Member m 
              WHERE m.CollectionId = @CollectionId 
                AND m.EmployeeId = i.EmployeeId 
                AND m.EntitlementId = @EntitlementId
          );

        IF EXISTS (
            SELECT 1 FROM OPENJSON(@PageJson, '$.value') WITH (
                ObjectId uniqueidentifier '$.id',
                ObjectType nvarchar(100) '$."@odata.type"'
            ) j 
            LEFT JOIN src.IdentityMap i ON i.ObjectId = j.ObjectId 
            WHERE j.ObjectType IS NULL 
               OR j.ObjectType <> '#microsoft.graph.user' 
               OR i.ObjectId IS NULL
        )
        BEGIN 
            ROLLBACK; 
            THROW 51000, 'Unknown/non-user group member: mapping must be investigated', 1; 
        END;

        UPDATE core.CollectionGroup 
        SET Pages = Pages + 1,
            Status = IIF(@LastPage = 1, 'Complete', 'Building') 
        WHERE CollectionId = @CollectionId AND EntitlementId = @EntitlementId;
        COMMIT;
    END
    ELSE IF @Action = 'Finish' 
    BEGIN
        IF (SELECT COUNT(*) FROM core.CollectionGroup WHERE CollectionId = @CollectionId AND Status = 'Complete') <> (SELECT COUNT(*) FROM src.GroupMap) 
           OR (SELECT COUNT(*) FROM src.GroupMap) = 0 
            THROW 51000, 'Incomplete group collection', 1;

        UPDATE core.Collection 
        SET Status = 'Complete', CompletedAt = SYSUTCDATETIME() 
        WHERE CollectionId = @CollectionId;
    END
    ELSE IF @Action = 'Fail' 
        UPDATE core.Collection SET Status = 'Failed', CompletedAt = SYSUTCDATETIME() WHERE CollectionId = @CollectionId;
    ELSE 
        THROW 51000, 'Unknown collection action', 1;
END;
GO

-- 2. Core Assessment Calculation Procedure
CREATE OR ALTER PROCEDURE core.usp_Assess 
    @RunId uniqueidentifier,
    @BusinessAsOf datetime2 = '2026-10-01T12:00:00',
    @InjectFailure bit = 0
AS
BEGIN
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    IF EXISTS (SELECT 1 FROM core.Assessment WHERE RunId = @RunId AND Status = 'Complete') RETURN;
    IF EXISTS (SELECT 1 FROM core.Assessment WHERE RunId = @RunId) 
        THROW 51000, 'Use a new run ID after a failed attempt', 1;

    DECLARE @collection uniqueidentifier, @source nvarchar(max), @live bit = 0;
    SELECT TOP(1) @collection = CollectionId 
    FROM core.Collection 
    WHERE Status = 'Complete' AND Mode = 'EntraLive' AND CompletedAt >= DATEADD(hour, -24, SYSUTCDATETIME()) 
    ORDER BY CompletedAt DESC;

    IF EXISTS (SELECT 1 FROM core.Collection c WHERE c.Status <> 'Complete' AND c.StartedAt > (SELECT StartedAt FROM core.Collection WHERE CollectionId = @collection)) 
        SET @collection = NULL;

    IF @collection IS NOT NULL SET @live = 1;

    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
        BEGIN TRAN;

        DECLARE @lock int;
        EXEC @lock = sys.sp_getapplock @Resource = 'RolePatrolAssessment', @LockMode = 'Exclusive', @LockOwner = 'Transaction', @LockTimeout = 0;
        IF @lock < 0 THROW 51000, 'Another assessment is running', 1;

        IF EXISTS (SELECT 1 FROM src.RoleVersion a JOIN src.RoleVersion b ON a.RoleId = b.RoleId AND a.VersionId < b.VersionId AND a.ValidFrom < COALESCE(b.ValidTo, '9999-12-31') AND b.ValidFrom < COALESCE(a.ValidTo, '9999-12-31')) 
            THROW 51000, 'Overlapping role versions', 1;

        IF EXISTS (SELECT 1 FROM src.Assignment a JOIN src.Assignment b ON a.EmployeeId = b.EmployeeId AND (a.VersionId < b.VersionId OR (a.VersionId = b.VersionId AND a.ValidFrom < b.ValidFrom)) AND a.ValidFrom < COALESCE(b.ValidTo, '9999-12-31') AND b.ValidFrom < COALESCE(a.ValidTo, '9999-12-31')) 
            THROW 51000, 'Overlapping employee assignments', 1;

        IF EXISTS (SELECT 1 FROM src.Ticket WHERE ResolvedAt < OpenedAt OR OpenedAt > @BusinessAsOf) 
            THROW 51000, 'Ticket clock invalid', 1;

        SELECT @source = (
            SELECT 
                JSON_QUERY((SELECT * FROM src.Role FOR JSON PATH)) roles,
                JSON_QUERY((SELECT * FROM src.RoleVersion FOR JSON PATH)) versions,
                JSON_QUERY((SELECT * FROM src.RoleEntitlement FOR JSON PATH)) baseline,
                JSON_QUERY((SELECT * FROM src.Employee FOR JSON PATH)) employees,
                JSON_QUERY((SELECT * FROM src.Move FOR JSON PATH)) moves,
                JSON_QUERY((SELECT * FROM src.Assignment FOR JSON PATH)) assignments,
                JSON_QUERY((SELECT * FROM src.Ticket FOR JSON PATH)) tickets,
                JSON_QUERY((SELECT * FROM src.Origin FOR JSON PATH)) origins,
                JSON_QUERY((SELECT * FROM src.Exception FOR JSON PATH)) exceptions,
                JSON_QUERY((SELECT * FROM src.Coverage FOR JSON PATH)) coverage,
                JSON_QUERY((SELECT * FROM core.MatchCandidate WHERE Status = 'Confirmed' FOR JSON PATH)) confirmedMatches 
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        );

        INSERT INTO core.Assessment (RunId, BusinessAsOf, StartedAt, CompletedAt, CollectionId, Status, RuleVersion, SourceJson)
        VALUES (@RunId, @BusinessAsOf, SYSUTCDATETIME(), NULL, @collection, 'Building', 'rp-rules-v2', @source);

        SELECT m.*, v.RoleId 
        INTO #eligible 
        FROM src.Move m 
        JOIN src.RoleVersion v ON v.VersionId = m.ToVersion 
        WHERE m.EffectiveAt >= DATEADD(day, -90, @BusinessAsOf) AND m.EffectiveAt <= DATEADD(day, -30, @BusinessAsOf);

        SELECT t.*, m.EventId, m.ToVersion, v.RoleId, COALESCE(t.EntitlementId, c.EntitlementId) AS VerifiedEntitlement 
        INTO #verified
        FROM src.Ticket t
        CROSS APPLY (
            SELECT TOP(1) * FROM src.Move m 
            WHERE m.EmployeeId = t.EmployeeId AND m.EffectiveAt <= t.OpenedAt 
            ORDER BY m.EffectiveAt DESC, m.EventId DESC
        ) m
        JOIN src.RoleVersion v ON v.VersionId = m.ToVersion
        OUTER APPLY (
            SELECT MIN(EntitlementId) AS EntitlementId 
            FROM core.MatchCandidate 
            WHERE TicketId = t.TicketId AND Status = 'Confirmed' 
            HAVING COUNT(*) = 1
        ) c
        WHERE t.TicketType LIKE '%Access%' 
          AND t.OpenedAt < DATEADD(day, 30, m.EffectiveAt) 
          AND ((t.MatchMethod IN ('Structured', 'Alias') AND t.EntitlementId IS NOT NULL) OR c.EntitlementId IS NOT NULL)
          AND EXISTS (
              SELECT 1 FROM src.Entitlement en 
              JOIN src.Role rr ON rr.RoleId = v.RoleId 
              WHERE en.EntitlementId = COALESCE(t.EntitlementId, c.EntitlementId) 
                AND en.ContextCode = t.ContextCode 
                AND (en.ContextCode NOT IN ('UK', 'US', 'DE', 'CA', 'MX') OR en.ContextCode = rr.Country)
          )
          AND NOT EXISTS (
              SELECT 1 FROM src.Move x 
              WHERE x.EmployeeId = m.EmployeeId AND x.EffectiveAt = m.EffectiveAt AND x.EventId <> m.EventId
          );

        INSERT INTO core.Evidence
        SELECT @RunId, t.RoleId, t.EmployeeId, e.DisplayName, t.EventId, t.ToVersion, t.TicketId, t.CanonicalRoot, t.VerifiedEntitlement, t.TicketText, t.OpenedAt, t.ResolvedAt
        FROM #verified t 
        JOIN #eligible m ON m.EventId = t.EventId 
        JOIN src.Employee e ON e.EmployeeId = t.EmployeeId;

        DECLARE @coverage varchar(16) = CASE WHEN (SELECT COUNT(*) FROM src.SourceStatus WHERE Complete = 1 AND CheckedAt >= DATEADD(hour, -24, SYSUTCDATETIME())) >= 1 THEN 'Complete' ELSE 'Partial' END;

        INSERT INTO core.Impact
        SELECT @RunId, r.RoleId, COUNT(DISTINCT e.EmployeeId),
            (SELECT COUNT(*) FROM #eligible m WHERE m.RoleId = r.RoleId),
            (SELECT COUNT(DISTINCT EmployeeId) FROM #eligible m WHERE m.RoleId = r.RoleId),
            COUNT(DISTINCT e.EventId),
            COUNT(e.TicketId),
            COUNT(DISTINCT e.CanonicalRoot),
            @coverage
        FROM src.Role r 
        LEFT JOIN core.Evidence e ON e.RunId = @RunId AND e.RoleId = r.RoleId 
        GROUP BY r.RoleId;

        INSERT INTO core.Peer
        SELECT @RunId, r.RoleId, en.EntitlementId, COUNT(DISTINCT a.EmployeeId), COUNT(DISTINCT m.EmployeeId), IIF(@live = 1, 'Complete', 'Unknown')
        FROM src.Role r 
        CROSS JOIN src.Entitlement en
        LEFT JOIN src.RoleVersion v ON v.RoleId = r.RoleId
        LEFT JOIN src.Assignment a ON a.VersionId = v.VersionId AND a.ValidFrom <= @BusinessAsOf AND (a.ValidTo IS NULL OR a.ValidTo > @BusinessAsOf) AND EXISTS (SELECT 1 FROM src.Employee e WHERE e.EmployeeId = a.EmployeeId AND e.Active = 1) AND @live = 1
        LEFT JOIN core.Member m ON m.CollectionId = @collection AND m.EmployeeId = a.EmployeeId AND m.EntitlementId = en.EntitlementId
        GROUP BY r.RoleId, en.EntitlementId;

        INSERT INTO core.Transfer
        SELECT @RunId, m.EventId, m.EmployeeId, v.RoleId, m.EffectiveAt, en.EntitlementId,
            CASE 
                WHEN @live = 0 THEN 'NeedsValidation'
                WHEN target.EntitlementId IS NOT NULL AND observed.EmployeeId IS NULL THEN 'ExpectedAddition'
                WHEN observed.EmployeeId IS NULL THEN 'NotObserved'
                WHEN target.EntitlementId IS NOT NULL THEN 'Retained'
                WHEN cov.ProvenanceComplete = 0 OR cov.ExceptionsComplete = 0 THEN 'NeedsValidation'
                WHEN EXISTS (SELECT 1 FROM src.Exception x WHERE x.EmployeeId = m.EmployeeId AND x.EntitlementId = en.EntitlementId AND x.Approved = 1 AND x.ValidFrom <= m.EffectiveAt AND x.ValidTo > m.EffectiveAt) THEN 'RetainedException'
                WHEN EXISTS (SELECT 1 FROM src.Origin o WHERE o.EmployeeId = m.EmployeeId AND o.EntitlementId = en.EntitlementId AND o.ValidFrom <= m.EffectiveAt AND (o.ValidTo IS NULL OR o.ValidTo > m.EffectiveAt) AND (o.OriginType <> 'Role' OR o.OriginVersion <> m.FromVersion)) THEN 'RetainedOther'
                WHEN EXISTS (SELECT 1 FROM src.Origin o WHERE o.EmployeeId = m.EmployeeId AND o.EntitlementId = en.EntitlementId AND o.OriginType = 'Role' AND o.OriginVersion = m.FromVersion AND o.ValidFrom <= m.EffectiveAt AND (o.ValidTo IS NULL OR o.ValidTo > m.EffectiveAt)) THEN 'ConditionalLoss'
                ELSE 'NeedsValidation' 
            END,
            'Conditional on modeled mover policy, effective-time provenance and complete observations; validate business need.'
        FROM src.Move m 
        JOIN src.RoleVersion v ON v.VersionId = m.ToVersion 
        CROSS JOIN src.Entitlement en 
        JOIN src.Coverage cov ON cov.EmployeeId = m.EmployeeId
        LEFT JOIN src.RoleEntitlement target ON target.VersionId = m.ToVersion AND target.EntitlementId = en.EntitlementId
        LEFT JOIN core.Member observed ON observed.CollectionId = @collection AND observed.EmployeeId = m.EmployeeId AND observed.EntitlementId = en.EntitlementId
        WHERE m.EffectiveAt > @BusinessAsOf AND m.EffectiveAt <= DATEADD(day, 14, @BusinessAsOf)
          AND (target.EntitlementId IS NOT NULL OR observed.EmployeeId IS NOT NULL OR EXISTS (SELECT 1 FROM src.RoleEntitlement old WHERE old.VersionId = m.FromVersion AND old.EntitlementId = en.EntitlementId));

        UPDATE c 
        SET RunId = @RunId, CaseVersion = CaseVersion + 1 
        FROM casework.ReviewCase c 
        JOIN core.Transfer t ON t.RunId = @RunId AND t.EmployeeId = c.EmployeeId AND t.TargetRole = c.RoleId AND t.EntitlementId = c.EntitlementId 
        WHERE t.Prediction IN ('ConditionalLoss', 'NeedsValidation');

        INSERT INTO casework.ReviewCase (RoleId, EntitlementId, EmployeeId, OwnerEmployeeId, RunId, Status, CaseVersion, DueAt)
        SELECT t.TargetRole, t.EntitlementId, t.EmployeeId, r.OwnerEmployeeId, @RunId, 'Open', 1, DATEADD(day, -1, t.EffectiveAt) 
        FROM core.Transfer t 
        JOIN src.Role r ON r.RoleId = t.TargetRole
        WHERE t.RunId = @RunId 
          AND t.Prediction IN ('ConditionalLoss', 'NeedsValidation') 
          AND NOT EXISTS (
              SELECT 1 FROM casework.ReviewCase c 
              WHERE c.RoleId = t.TargetRole AND c.EmployeeId = t.EmployeeId AND c.EntitlementId = t.EntitlementId
          );

        UPDATE c 
        SET RunId = @RunId, CaseVersion = CaseVersion + 1 
        FROM casework.ReviewCase c
        WHERE c.RunId <> @RunId 
          AND EXISTS (
              SELECT 1 FROM core.Evidence e 
              WHERE e.RunId = @RunId AND e.RoleId = c.RoleId AND e.EntitlementId = c.EntitlementId AND e.EmployeeId = c.EmployeeId
          );

        INSERT INTO casework.ReviewCase (RoleId, EntitlementId, EmployeeId, OwnerEmployeeId, RunId, Status, CaseVersion, DueAt)
        SELECT e.RoleId, e.EntitlementId, MIN(e.EmployeeId), r.OwnerEmployeeId, @RunId, 'Open', 1, DATEADD(day, 7, @BusinessAsOf)
        FROM core.Evidence e 
        JOIN src.Role r ON r.RoleId = e.RoleId
        WHERE e.RunId = @RunId 
          AND NOT EXISTS (
              SELECT 1 FROM casework.ReviewCase c 
              WHERE c.RoleId = e.RoleId AND c.EntitlementId = e.EntitlementId
          )
        GROUP BY e.RoleId, e.EntitlementId, r.OwnerEmployeeId;

        SET DATEFIRST 1;
        UPDATE casework.ReviewCase 
        SET DueAt = DATEADD(day, CASE DATEPART(weekday, DueAt) WHEN 6 THEN -1 WHEN 7 THEN -2 ELSE 0 END, DueAt) 
        WHERE RunId = @RunId;

        IF @InjectFailure = 1 THROW 51000, 'Injected publication failure', 1;

        UPDATE core.Assessment SET Status = 'Complete', CompletedAt = SYSUTCDATETIME() WHERE RunId = @RunId;
        UPDATE core.Published SET RunId = @RunId WHERE StreamId = 1;
        IF @@ROWCOUNT = 0 INSERT INTO core.Published VALUES (1, @RunId);

        INSERT INTO audit.Event (Actor, ActionName, ObjectId, Detail) 
        VALUES (USER_NAME(), 'AssessmentPublished', CONVERT(nvarchar(36), @RunId), 'Snapshot counts and evidence committed atomically.');

        COMMIT;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        INSERT INTO core.Assessment VALUES (@RunId, @BusinessAsOf, SYSUTCDATETIME(), SYSUTCDATETIME(), NULL, 'Failed', 'rp-rules-v2', '{}');
        THROW;
    END CATCH;
END;
GO

-- 3. API Gateway Router
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
                WHEN 409 THEN 'Stale evidence, duplicate conflict or invalid transition; reload' 
                WHEN 400 THEN ERROR_MESSAGE() 
                ELSE 'Backend failed; check protected workflow run history' 
            END AS error 
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        ) AS ResponseJson;
    END CATCH;
END;
GO

-- 4. API Read Operations (Full varchar(16) Actor Support)
CREATE OR ALTER PROCEDURE api.usp_Read 
    @Payload nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @actor varchar(16) = (SELECT EmployeeId FROM core.Principal WHERE DbUser = USER_NAME()),
            @op varchar(20) = JSON_VALUE(@Payload, '$.op'),
            @role varchar(24) = JSON_VALUE(@Payload, '$.roleId'),
            @run uniqueidentifier = TRY_CONVERT(uniqueidentifier, JSON_VALUE(@Payload, '$.runId')),
            @result nvarchar(max);

    IF @actor IS NULL THROW 51003, 'Unmapped database caller', 1;
    IF @run IS NULL SELECT @run = RunId FROM core.Published WHERE StreamId = 1;
    IF @run IS NULL 
    BEGIN 
        SELECT 200 AS HttpStatus, N'{"status":"No completed assessment","roles":[]}' AS ResponseJson; 
        RETURN; 
    END;

    IF NOT EXISTS (SELECT 1 FROM core.Assessment WHERE RunId = @run AND Status = 'Complete') 
        THROW 51004, 'Assessment unavailable', 1;

    IF @op = 'overview' 
    BEGIN
        ;WITH scoped AS (
            SELECT i.*, r.JobTitle, r.CostCenter, r.Country, r.OwnerEmployeeId,
                   CASE WHEN i.Coverage = 'Complete' AND i.AffectedEmployees > 0 AND i.EligibleEvents > 0 
                        THEN DENSE_RANK() OVER (PARTITION BY IIF(i.Coverage = 'Complete' AND i.AffectedEmployees > 0 AND i.EligibleEvents > 0, 1, 0) ORDER BY i.AffectedEmployees DESC) 
                   END AS PriorityRank 
            FROM core.Impact i 
            JOIN src.Role r ON r.RoleId = i.RoleId 
            JOIN core.Permission p ON p.EmployeeId = @actor AND p.RoleId = i.RoleId 
            WHERE i.RunId = @run
        )
        SELECT @result = (
            SELECT CONVERT(varchar(36), @run) AS runId,
                   JSON_QUERY((SELECT BusinessAsOf, CompletedAt, RuleVersion, CollectionId FROM core.Assessment WHERE RunId = @run FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS assessment,
                   JSON_QUERY((SELECT * FROM scoped ORDER BY CASE WHEN PriorityRank IS NULL THEN 1 ELSE 0 END, PriorityRank, RoleId FOR JSON PATH)) AS roles 
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        );
    END
    ELSE IF @op = 'role' 
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM core.Permission WHERE EmployeeId = @actor AND RoleId = @role) 
            THROW 51003, 'Role outside scope', 1;

        DECLARE @detail bit = (SELECT CanReadDetail FROM core.Permission WHERE EmployeeId = @actor AND RoleId = @role);
        SELECT @result = (
            SELECT CONVERT(varchar(36), @run) AS runId,
                   @detail AS canReadDetail,
                   JSON_QUERY((SELECT * FROM core.Impact WHERE RunId = @run AND RoleId = @role FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS impact,
                   JSON_QUERY((SELECT * FROM core.Evidence WHERE RunId = @run AND RoleId = @role AND @detail = 1 ORDER BY EmployeeId, TicketId FOR JSON PATH)) AS evidence,
                   JSON_QUERY((SELECT * FROM core.Transfer WHERE RunId = @run AND TargetRole = @role AND @detail = 1 FOR JSON PATH)) AS transfers,
                   JSON_QUERY((SELECT * FROM core.Peer WHERE RunId = @run AND RoleId = @role FOR JSON PATH)) AS peers,
                   JSON_QUERY((SELECT c.*, p.CanDecide, p.CanIam FROM casework.ReviewCase c JOIN core.Permission p ON p.RoleId = c.RoleId AND p.EmployeeId = @actor WHERE c.RoleId = @role AND @detail = 1 FOR JSON PATH)) AS cases 
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        );
    END
    ELSE IF @op = 'history' 
        SELECT @result = (
            SELECT RunId, BusinessAsOf, CompletedAt, RuleVersion 
            FROM core.Assessment a 
            WHERE Status = 'Complete' 
              AND EXISTS (SELECT 1 FROM core.Impact i JOIN core.Permission p ON p.RoleId = i.RoleId AND p.EmployeeId = @actor WHERE i.RunId = a.RunId) 
            ORDER BY CompletedAt DESC 
            FOR JSON PATH
        );
    ELSE IF @op = 'worklist' 
        SELECT @result = (
            SELECT c.*, p.CanDecide, p.CanIam 
            FROM casework.ReviewCase c 
            JOIN core.Permission p ON p.RoleId = c.RoleId AND p.EmployeeId = @actor AND p.CanReadDetail = 1 
            ORDER BY DueAt 
            FOR JSON PATH
        );
    ELSE 
        THROW 51000, 'Unsupported read operation', 1;

    SELECT 200 AS HttpStatus, COALESCE(@result, N'{}') AS ResponseJson;
END;
GO

-- 5. API Decide Operation (Full varchar(16) Actor Support)
CREATE OR ALTER PROCEDURE api.usp_Decide 
    @Payload nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    DECLARE @actor varchar(16) = (SELECT EmployeeId FROM core.Principal WHERE DbUser = USER_NAME()),
            @case int = TRY_CONVERT(int, JSON_VALUE(@Payload, '$.caseId')),
            @ver int = TRY_CONVERT(int, JSON_VALUE(@Payload, '$.caseVersion')),
            @key uniqueidentifier = TRY_CONVERT(uniqueidentifier, JSON_VALUE(@Payload, '$.idempotencyKey')),
            @decision varchar(32) = JSON_VALUE(@Payload, '$.decision'),
            @rationale nvarchar(1000) = JSON_VALUE(@Payload, '$.rationale'),
            @run uniqueidentifier = TRY_CONVERT(uniqueidentifier, JSON_VALUE(@Payload, '$.runId')),
            @id uniqueidentifier = NEWID(),
            @hash varbinary(32) = HASHBYTES('SHA2_256', @Payload);

    IF @actor IS NULL THROW 51003, 'Unmapped caller', 1;
    IF @key IS NULL OR @case IS NULL OR @ver IS NULL OR @run IS NULL 
       OR @decision NOT IN ('RequestIamReview', 'NeedsInformation', 'NotRequired') 
       OR NULLIF(LTRIM(RTRIM(@rationale)), '') IS NULL 
       OR LEN(JSON_VALUE(@Payload, '$.rationale')) > 1000 
        THROW 51000, 'Invalid decision request', 1;

    BEGIN TRY
        BEGIN TRAN;
        IF NOT EXISTS (
            SELECT 1 FROM casework.ReviewCase c WITH (UPDLOCK, HOLDLOCK) 
            JOIN core.Permission p ON p.RoleId = c.RoleId AND p.EmployeeId = @actor AND p.CanDecide = 1 
            WHERE c.CaseId = @case AND c.OwnerEmployeeId = @actor AND c.EmployeeId <> @actor
        ) 
            THROW 51003, 'Not authorized to decide', 1;

        IF EXISTS (SELECT 1 FROM casework.Decision WHERE IdempotencyKey = @key) 
        BEGIN
            IF NOT EXISTS (SELECT 1 FROM casework.Decision WHERE IdempotencyKey = @key AND Actor = @actor AND RequestHash = @hash) 
                THROW 51009, 'Idempotency conflict', 1;
            SELECT @id = DecisionId FROM casework.Decision WHERE IdempotencyKey = @key; 
            COMMIT;
            SELECT 200 AS HttpStatus, (SELECT CONVERT(varchar(36), @id) AS decisionId, 'Already recorded' AS message FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS ResponseJson; 
            RETURN;
        END;

        IF NOT EXISTS (SELECT 1 FROM casework.ReviewCase WHERE CaseId = @case AND CaseVersion = @ver AND RunId = @run AND Status IN ('Open', 'InReview', 'NeedsInformation')) 
            THROW 51009, 'Stale case/evidence or invalid transition; reload', 1;

        INSERT INTO casework.Decision (DecisionId, CaseId, Actor, Decision, Rationale, RunId, IdempotencyKey, RequestHash, CreatedAt, DecisionMode)
        VALUES (@id, @case, @actor, @decision, @rationale, @run, @key, @hash, SYSUTCDATETIME(), 'EntraHtml');

        UPDATE casework.ReviewCase 
        SET Status = CASE @decision WHEN 'RequestIamReview' THEN 'HandoffRequested' WHEN 'NeedsInformation' THEN 'NeedsInformation' ELSE 'Rejected' END,
            CaseVersion = CaseVersion + 1 
        WHERE CaseId = @case;

        INSERT INTO audit.Event (Actor, ActionName, ObjectId, Detail) 
        VALUES (@actor, 'OwnerDecision', CONVERT(nvarchar(20), @case), CONCAT(@decision, '; evidence ', @run, '; decision ', @id));

        COMMIT;
        SELECT 200 AS HttpStatus, (SELECT CONVERT(varchar(36), @id) AS decisionId, 'Recorded; no access changed' AS message FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS ResponseJson;
    END TRY 
    BEGIN CATCH 
        IF @@TRANCOUNT > 0 ROLLBACK; 
        THROW; 
    END CATCH;
END;
GO

-- 6. API Scenario What-If Procedure (Full varchar(16) Support)
CREATE OR ALTER PROCEDURE api.usp_Scenario 
    @Payload nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @actor varchar(16) = (SELECT EmployeeId FROM core.Principal WHERE DbUser = USER_NAME()),
            @run uniqueidentifier = TRY_CONVERT(uniqueidentifier, JSON_VALUE(@Payload, '$.runId')),
            @role varchar(24) = JSON_VALUE(@Payload, '$.roleId'),
            @ent varchar(24) = JSON_VALUE(@Payload, '$.entitlementId'),
            @change varchar(10) = JSON_VALUE(@Payload, '$.change'),
            @effective datetime2 = TRY_CONVERT(datetime2, JSON_VALUE(@Payload, '$.effectiveAt')),
            @source nvarchar(max),
            @collection uniqueidentifier,
            @asof datetime2,
            @id uniqueidentifier = NEWID(),
            @result nvarchar(max);

    IF NOT EXISTS (SELECT 1 FROM core.Permission WHERE EmployeeId = @actor AND RoleId = @role AND CanReadDetail = 1 AND (CanDecide = 1 OR CanIam = 1)) 
        THROW 51003, 'Scenario outside scope', 1;

    SELECT @source = SourceJson, @collection = CollectionId, @asof = BusinessAsOf 
    FROM core.Assessment 
    WHERE RunId = @run AND Status = 'Complete';

    IF @source IS NULL OR @effective IS NULL OR @effective < @asof OR @change NOT IN ('Add', 'Remove') OR NOT EXISTS (SELECT 1 FROM src.Entitlement WHERE EntitlementId = @ent) 
        THROW 51000, 'Invalid scenario request', 1;

    DECLARE @members TABLE(EmployeeId varchar(16), Effect varchar(40));

    ;WITH assignments AS (
        SELECT * FROM OPENJSON(@source, '$.assignments') WITH (
            EmployeeId varchar(16),
            VersionId varchar(32),
            ValidFrom datetime2,
            ValidTo datetime2
        )
    ),
    versions AS (
        SELECT * FROM OPENJSON(@source, '$.versions') WITH (
            VersionId varchar(32),
            RoleId varchar(24)
        )
    ),
    origins AS (
        SELECT * FROM OPENJSON(@source, '$.origins') WITH (
            EmployeeId varchar(16),
            EntitlementId varchar(24),
            OriginType varchar(20),
            OriginVersion varchar(32),
            ValidFrom datetime2,
            ValidTo datetime2
        )
    ),
    exceptions AS (
        SELECT * FROM OPENJSON(@source, '$.exceptions') WITH (
            EmployeeId varchar(16),
            EntitlementId varchar(24),
            ValidFrom datetime2,
            ValidTo datetime2,
            Approved bit
        )
    ),
    coverage AS (
        SELECT * FROM OPENJSON(@source, '$.coverage') WITH (
            EmployeeId varchar(16),
            ProvenanceComplete bit,
            ExceptionsComplete bit
        )
    )
    INSERT INTO @members
    SELECT a.EmployeeId,
        CASE 
            WHEN @collection IS NULL THEN 'UnknownObservation'
            WHEN @change = 'Add' AND obs.EmployeeId IS NULL THEN 'PotentialRecipient'
            WHEN @change = 'Add' THEN 'AlreadyObserved'
            WHEN obs.EmployeeId IS NULL THEN 'NotObserved'
            WHEN cov.ProvenanceComplete = 0 OR cov.ExceptionsComplete = 0 THEN 'UnknownProvenance'
            WHEN EXISTS (SELECT 1 FROM exceptions x WHERE x.EmployeeId = a.EmployeeId AND x.EntitlementId = @ent AND x.Approved = 1 AND x.ValidFrom <= @effective AND x.ValidTo > @effective) THEN 'RetainedException'
            WHEN EXISTS (SELECT 1 FROM origins o WHERE o.EmployeeId = a.EmployeeId AND o.EntitlementId = @ent AND o.ValidFrom <= @effective AND (o.ValidTo IS NULL OR o.ValidTo > @effective) AND (o.OriginType <> 'Role' OR o.OriginVersion <> a.VersionId)) THEN 'RetainedOther'
            WHEN EXISTS (SELECT 1 FROM origins o WHERE o.EmployeeId = a.EmployeeId AND o.EntitlementId = @ent AND o.OriginType = 'Role' AND o.OriginVersion = a.VersionId AND o.ValidFrom <= @effective AND (o.ValidTo IS NULL OR o.ValidTo > @effective)) THEN 'PotentialLoss' 
            ELSE 'UnknownProvenance' 
        END
    FROM assignments a 
    JOIN versions v ON v.VersionId = a.VersionId 
    JOIN coverage cov ON cov.EmployeeId = a.EmployeeId
    LEFT JOIN core.Member obs ON obs.CollectionId = @collection AND obs.EmployeeId = a.EmployeeId AND obs.EntitlementId = @ent
    WHERE v.RoleId = @role AND a.ValidFrom <= @asof AND (a.ValidTo IS NULL OR a.ValidTo > @asof);

    SELECT @result = (
        SELECT CONVERT(varchar(36), @id) AS scenarioId,
               @change AS proposedChange,
               @ent AS entitlementId,
               @effective AS effectiveAt,
               'Scenario only; no source or access changes' AS label,
               CASE WHEN EXISTS (SELECT 1 FROM src.Entitlement WHERE EntitlementId = @ent AND Risk IN ('Elevated', 'High', 'Administrative'))
                    THEN 'Specialist policy review required; elevated privilege detected' 
                    ELSE 'Business-need review required; not a complete SoD check' 
               END AS policyNotice,
               JSON_QUERY((SELECT Effect, COUNT(*) AS employeeCount FROM @members GROUP BY Effect FOR JSON PATH)) AS counts,
               JSON_QUERY((SELECT * FROM @members FOR JSON PATH)) AS members,
               JSON_QUERY((SELECT EmployeeId, EventId, CASE WHEN @change = 'Add' THEN 'TargetIncludesEntitlement' ELSE 'TargetExcludesEntitlement' END AS targetDelta FROM core.Transfer WHERE RunId = @run AND TargetRole = @role AND EntitlementId = @ent FOR JSON PATH)) AS upcomingTransfers
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    );

    INSERT INTO scenario.Result (ScenarioId, Actor, RunId, RoleId, CreatedAt, ResultJson)
    VALUES (@id, @actor, @run, @role, SYSUTCDATETIME(), @result);

    INSERT INTO audit.Event (Actor, ActionName, ObjectId, Detail) 
    VALUES (@actor, 'ScenarioCreated', CONVERT(nvarchar(36), @id), 'Isolated projected delta; source untouched.');

    SELECT 200 AS HttpStatus, @result AS ResponseJson;
END;
GO

-- 7. API IAM Reference Procedure
CREATE OR ALTER PROCEDURE api.usp_Iam 
    @Payload nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON; 
    SET XACT_ABORT ON;

    DECLARE @actor varchar(16) = (SELECT EmployeeId FROM core.Principal WHERE DbUser = USER_NAME()),
            @case int = TRY_CONVERT(int, JSON_VALUE(@Payload, '$.caseId')),
            @reference nvarchar(200) = JSON_VALUE(@Payload, '$.reference');

    IF NULLIF(LTRIM(RTRIM(@reference)), '') IS NULL 
        THROW 51000, 'Reference required', 1;
    IF NOT EXISTS (SELECT 1 FROM casework.ReviewCase c JOIN core.Permission p ON p.RoleId = c.RoleId AND p.EmployeeId = @actor AND p.CanIam = 1 WHERE c.CaseId = @case) 
        THROW 51003, 'IAM scope denied', 1;

    BEGIN TRAN;
    UPDATE casework.ReviewCase 
    SET ExternalReference = @reference, CaseVersion = CaseVersion + 1 
    WHERE CaseId = @case;

    INSERT INTO audit.Event (Actor, ActionName, ObjectId, Detail) 
    VALUES (@actor, 'ExternalReference', CONVERT(nvarchar(20), @case), @reference);

    COMMIT;
    SELECT 200 AS HttpStatus, N'{"message":"Reference saved; outcome not automatically verified"}' AS ResponseJson;
END;
GO

-- 8. Core Dataset Validation (Dynamic Checks - Zero Hardcoded Legacy Counts)
CREATE OR ALTER PROCEDURE core.usp_Validate
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @run uniqueidentifier = (SELECT RunId FROM core.Published WHERE StreamId = 1);
    IF @run IS NULL THROW 51000, 'No published assessment', 1;
    IF NOT EXISTS (SELECT 1 FROM core.Impact WHERE RunId = @run) 
        THROW 51000, 'No impact records calculated for published run', 1;
    IF NOT EXISTS (SELECT 1 FROM core.Assessment WHERE RunId = @run AND Status = 'Complete') 
        THROW 51000, 'Published assessment status is not complete', 1;
    
    SELECT 'Team20 dataset engine validation passed dynamically.' AS Validation, @run AS RunId,
           (SELECT COUNT(*) FROM core.Impact WHERE RunId = @run) AS MonitoredRoles,
           (SELECT COUNT(*) FROM core.Evidence WHERE RunId = @run) AS VerifiedEvidenceTickets;
END;
GO

SELECT 'Greenfield Engine Procedures for Team20 installed successfully.' AS Result;
GO
