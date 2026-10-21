/* T20 Role Patrol - Evaluator Permissions & Decision Authorization
   Grants full Decision and Simulation rights to role leads GID0004 and GID0001
   so evaluators can test What-If scenarios and submit casework decisions
   on any portfolio role. */
SET NOCOUNT ON;

-- 1. Ensure CanDecide = 1 and CanIam = 1 for GID0004 and GID0001
UPDATE p
SET CanDecide = 1, CanIam = 1
FROM core.Permission p
WHERE p.EmployeeId IN ('GID0004', 'GID0001');

-- 2. Update api.usp_Decide to allow callers with CanDecide = 1 on the role to decide
GO
CREATE OR ALTER PROCEDURE api.usp_Decide 
    @Payload nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @actor varchar(16) = (SELECT EmployeeId FROM core.Principal WHERE DbUser = USER_NAME()),
            @key uniqueidentifier = TRY_CONVERT(uniqueidentifier, JSON_VALUE(@Payload, '$.idempotencyKey')),
            @case bigint = TRY_CONVERT(bigint, JSON_VALUE(@Payload, '$.caseId')),
            @ver int = TRY_CONVERT(int, JSON_VALUE(@Payload, '$.caseVersion')),
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
            WHERE c.CaseId = @case AND (c.OwnerEmployeeId = @actor OR p.CanDecide = 1) AND c.EmployeeId <> @actor
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
        DECLARE @err int = ERROR_NUMBER(), @msg nvarchar(2048) = ERROR_MESSAGE(); 
        IF @err IN (51000, 51003, 51009) THROW; 
        THROW 50000, @msg, 1; 
    END CATCH;
END;
GO

SELECT EmployeeId, COUNT(*) AS Roles, SUM(CONVERT(int, CanDecide)) AS Decidable, SUM(CONVERT(int, CanIam)) AS IamAuthorized
FROM core.Permission WHERE EmployeeId IN ('GID0004', 'GID0001')
GROUP BY EmployeeId;
GO
