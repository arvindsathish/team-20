-- 1. Ensure Logic App users exist from external provider
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Team20_la_api_a_204508')
    BEGIN TRY CREATE USER [Team20_la_api_a_204508] FROM EXTERNAL PROVIDER; ALTER ROLE db_datareader ADD MEMBER [Team20_la_api_a_204508]; ALTER ROLE db_datawriter ADD MEMBER [Team20_la_api_a_204508]; GRANT EXECUTE TO [Team20_la_api_a_204508]; END TRY BEGIN CATCH END CATCH;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = 'Team20_la_api_b_204508')
    BEGIN TRY CREATE USER [Team20_la_api_b_204508] FROM EXTERNAL PROVIDER; ALTER ROLE db_datareader ADD MEMBER [Team20_la_api_b_204508]; ALTER ROLE db_datawriter ADD MEMBER [Team20_la_api_b_204508]; GRANT EXECUTE TO [Team20_la_api_b_204508]; END TRY BEGIN CATCH END CATCH;

-- 2. Map Principals in core.Principal
DELETE FROM core.Principal WHERE DbUser IN ('Team20_la_api_a_204508', 'Team20_la_api_b_204508', 'dbo', 'rajansaaz002_outlook.com#EXT#@rajansaaz002outlook.onmicrosoft.com');
INSERT INTO core.Principal (EmployeeId, DbUser) VALUES ('GID0004', 'Team20_la_api_a_204508');
INSERT INTO core.Principal (EmployeeId, DbUser) VALUES ('GID0001', 'Team20_la_api_b_204508');
INSERT INTO core.Principal (EmployeeId, DbUser) VALUES ('GID0004', 'dbo');
IF ('rajansaaz002_outlook.com#EXT#@rajansaaz002outlook.onmicrosoft.com' <> 'dbo')
    INSERT INTO core.Principal (EmployeeId, DbUser) VALUES ('GID0004', 'rajansaaz002_outlook.com#EXT#@rajansaaz002outlook.onmicrosoft.com');

-- 3. Seed Role Owner Permissions
DELETE FROM core.Permission WHERE EmployeeId IN ('GID0004', 'GID0001');
INSERT INTO core.Permission (EmployeeId, RoleId, CanReadDetail, CanDecide, CanIam)
SELECT 'GID0004', RoleId, 1, 1, 1 FROM src.Role WHERE OwnerEmployeeId = 'GID0004';

INSERT INTO core.Permission (EmployeeId, RoleId, CanReadDetail, CanDecide, CanIam)
SELECT 'GID0001', RoleId, 1, 1, 1 FROM src.Role WHERE OwnerEmployeeId = 'GID0001';
