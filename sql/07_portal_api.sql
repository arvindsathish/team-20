/* T20 Role Patrol - Portal API additions
   - src.Application (loaded from APPLICATION_MASTER.csv by scripts/Apply-PortalApi.ps1)
   - api.usp_Catalog: live catalog the portal needs (entitlements, applications, role blueprints, portfolio counts)
   - api.usp_Gateway: final router (adds 'catalog' to the ticket-search router)
   Every value returned is read from Azure SQL tables; nothing is precomputed in the browser bundle. */
SET NOCOUNT ON;
GO

IF OBJECT_ID('src.Application') IS NULL
CREATE TABLE src.Application(
    ApplicationId varchar(12) NOT NULL PRIMARY KEY,
    Name nvarchar(80) NOT NULL,
    Category nvarchar(60) NULL,
    Active bit NOT NULL
);
GO

CREATE OR ALTER PROCEDURE api.usp_Catalog
    @Payload nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @actor varchar(16) = (SELECT EmployeeId FROM core.Principal WHERE DbUser = USER_NAME()),
            @result nvarchar(max);

    IF @actor IS NULL THROW 51003, 'Unmapped database caller', 1;

    SELECT @result = (
        SELECT
            JSON_QUERY(COALESCE((SELECT EntitlementId, DisplayName, Risk, ContextCode FROM src.Entitlement ORDER BY EntitlementId FOR JSON PATH), N'[]')) AS entitlements,
            JSON_QUERY(COALESCE((SELECT ApplicationId, Name, Category FROM src.Application ORDER BY ApplicationId FOR JSON PATH), N'[]')) AS applications,
            JSON_QUERY(COALESCE((
                SELECT r.RoleId, r.JobTitle, r.CostCenter, r.Country, r.OwnerEmployeeId, p.CanReadDetail, p.CanDecide, p.CanIam,
                       JSON_QUERY(COALESCE((
                           SELECT re.EntitlementId
                           FROM src.RoleVersion v
                           JOIN src.RoleEntitlement re ON re.VersionId = v.VersionId
                           WHERE v.RoleId = r.RoleId AND v.ValidTo IS NULL
                           ORDER BY re.EntitlementId
                           FOR JSON PATH), N'[]')) AS entitlements
                FROM src.Role r
                JOIN core.Permission p ON p.RoleId = r.RoleId AND p.EmployeeId = @actor
                ORDER BY r.RoleId
                FOR JSON PATH), N'[]')) AS roles,
            JSON_QUERY((
                SELECT (SELECT COUNT(*) FROM src.Employee) AS Employees,
                       (SELECT COUNT(*) FROM src.Ticket) AS Tickets,
                       (SELECT COUNT(*) FROM src.Move) AS Moves,
                       (SELECT COUNT(*) FROM src.Role WHERE RoleId NOT IN ('NEW_HIRE', 'LEAVER')) AS Roles
                FOR JSON PATH, WITHOUT_ARRAY_WRAPPER)) AS portfolio,
            @actor AS actor
        FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
    );

    SELECT 200 AS HttpStatus, @result AS ResponseJson;
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

        DECLARE @op varchar(24) = JSON_VALUE(@Payload, '$.op');
        IF @op IN ('ticketSearch', 'ticketSearchDecision')
        BEGIN
            IF @op = 'ticketSearchDecision' SET @Payload = JSON_MODIFY(@Payload, '$.searchAction', 'Decision');
            EXEC api.usp_TicketSearch @Payload;
        END
        ELSE IF @op IN ('overview', 'role', 'history', 'worklist') EXEC api.usp_Read @Payload;
        ELSE IF @op = 'catalog' EXEC api.usp_Catalog @Payload;
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

SELECT 'Portal API (catalog + final gateway) installed.' AS Result;
GO
