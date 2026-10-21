/* T20 Role Patrol - Least-Privilege Grants & Dataset Owner Permissions
   Template script executed by Member 2 / Deploy-TrackB.
   Replaces __API_A__, __API_B__, __COLLECTOR__, __FACTORY__,
   __API_A_SID__, __API_B_SID__, __COLLECT_SID__, __ADF_SID__ dynamically. */

-- 1. Create External Users for Managed Identities using Binary Hex SIDs
IF DATABASE_PRINCIPAL_ID('__API_A__') IS NULL 
    CREATE USER [__API_A__] WITH SID=__API_A_SID__, TYPE=E;

IF DATABASE_PRINCIPAL_ID('__API_B__') IS NULL 
    CREATE USER [__API_B__] WITH SID=__API_B_SID__, TYPE=E;

IF DATABASE_PRINCIPAL_ID('__COLLECTOR__') IS NULL 
    CREATE USER [__COLLECTOR__] WITH SID=__COLLECT_SID__, TYPE=E;

IF DATABASE_PRINCIPAL_ID('__FACTORY__') IS NULL 
    CREATE USER [__FACTORY__] WITH SID=__ADF_SID__, TYPE=E;

-- 2. Grant Scoped Least-Privilege EXECUTE Rights
GRANT EXECUTE ON OBJECT::api.usp_Gateway TO [__API_A__];
GRANT EXECUTE ON OBJECT::api.usp_Gateway TO [__API_B__];
GRANT EXECUTE ON OBJECT::core.usp_Collect TO [__COLLECTOR__];
GRANT EXECUTE ON OBJECT::core.usp_GroupMap TO [__COLLECTOR__];
GRANT EXECUTE ON OBJECT::core.usp_Ingest TO [__FACTORY__];
GRANT EXECUTE ON OBJECT::core.usp_Assess TO [__FACTORY__];

-- 3. Map Real Dataset Role Owners to Logic Apps
-- Owner A (US Lead): Doreni Arvenor (GID0004) -> ApiA
-- Owner B (Canada Lead): Alira Arvenor (GID0001) -> ApiB
DELETE FROM core.Principal WHERE DbUser IN ('__API_A__', '__API_B__');
INSERT INTO core.Principal (DbUser, EmployeeId) VALUES ('__API_A__', 'GID0004');
INSERT INTO core.Principal (DbUser, EmployeeId) VALUES ('__API_B__', 'GID0001');

-- 4. Seed Permissions for Dataset Role Owners
DELETE FROM core.Permission WHERE EmployeeId IN ('GID0004', 'GID0001');
INSERT INTO core.Permission (EmployeeId, RoleId, CanReadDetail, CanDecide, CanIam)
SELECT 'GID0004', RoleId, 1, 1, 0 FROM src.Role WHERE OwnerEmployeeId = 'GID0004';

INSERT INTO core.Permission (EmployeeId, RoleId, CanReadDetail, CanDecide, CanIam)
SELECT 'GID0001', RoleId, 1, 1, 0 FROM src.Role WHERE OwnerEmployeeId = 'GID0001';

SELECT 'Managed Identity SQL users and permissions provisioned for GID0004 and GID0001.' AS Result;
GO
