/* T20 Role Patrol - Portfolio read access for the two Role Owner leads.
   Owners keep decision rights ONLY on roles they own (usp_Decide additionally enforces
   OwnerEmployeeId = caller). Every other real role is granted read-only visibility so the
   portfolio view and Role Differentiator can compare roles across regions. */
SET NOCOUNT ON;

INSERT INTO core.Permission (EmployeeId, RoleId, CanReadDetail, CanDecide, CanIam)
SELECT l.EmployeeId, r.RoleId, 1, 0, 0
FROM (VALUES ('GID0004'), ('GID0001')) AS l(EmployeeId)
CROSS JOIN src.Role r
WHERE r.RoleId NOT IN ('NEW_HIRE', 'LEAVER')
  AND NOT EXISTS (SELECT 1 FROM core.Permission p WHERE p.EmployeeId = l.EmployeeId AND p.RoleId = r.RoleId);

SELECT EmployeeId, COUNT(*) AS Roles, SUM(CONVERT(int, CanDecide)) AS Decidable
FROM core.Permission GROUP BY EmployeeId;
