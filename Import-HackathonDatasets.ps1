<#
.SYNOPSIS
    Ingests the 8 Hackathon CSV dataset files into Azure SQL Database for Role Patrol.
.DESCRIPTION
    Loads EMPLOYEE_IDENTITY.csv, BUSINESS_ROLE_MASTER.csv, APPLICATION_MASTER.csv,
    ENTITLEMENT_CATALOG.csv, ROLE_ENTITLEMENTS.csv, ROLE_ASSIGNMENTS.csv, JML_EVENTS.csv,
    and ACCESS_REQUEST_TICKETS.csv into the src.* tables.
.PARAMETER SqlServer
    Azure SQL Logical Server name or FQDN (e.g. team20-sql-204508.database.windows.net).
.PARAMETER Database
    Database name (default: t020_rolepatrol).
.PARAMETER DatasetDir
    Directory containing the 8 CSV files (default: .\datasets).
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$false)][string]$SqlServer,
    [Parameter(Mandatory=$false)][string]$Database,
    [Parameter(Mandatory=$false)][string]$NamesFile = ".\names.json",
    [Parameter(Mandatory=$false)][string]$DatasetDir = ".\datasets"
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$resolvedNames = $null
$nameCandidates = @(
    $NamesFile,
    (Join-Path $PWD $NamesFile),
    (Join-Path $scriptDir $NamesFile),
    (Join-Path (Split-Path -Parent $scriptDir) "names.json"),
    (Join-Path $PWD "names.json"),
    ".\names.json",
    "..\names.json"
)
foreach ($cand in $nameCandidates) {
    if ($cand -and (Test-Path $cand -PathType Leaf)) {
        $resolvedNames = (Resolve-Path $cand).Path
        break
    }
}
if (-not $resolvedNames) { $resolvedNames = Join-Path $scriptDir $NamesFile }

if (Test-Path $resolvedNames) {
    $names = Get-Content $resolvedNames | ConvertFrom-Json
    if (-not $SqlServer) { $SqlServer = $names.SqlServer }
    if (-not $Database)  { $Database  = $names.Database }
}

if (-not $SqlServer) { $SqlServer = "t020-sql-36de74" }
if (-not $Database)  { $Database  = "t020_rolepatrol" }

if (-not $SqlServer.Contains(".")) {
    $SqlServer = "$SqlServer.database.windows.net"
}

$resolvedDataset = $null
$datasetCandidates = @(
    $DatasetDir,
    (Join-Path $PWD $DatasetDir),
    (Join-Path $scriptDir $DatasetDir),
    (Join-Path (Split-Path -Parent $scriptDir) "datasets"),
    (Join-Path $PWD "datasets"),
    ".\datasets",
    "..\datasets"
)
foreach ($cand in $datasetCandidates) {
    if ($cand -and (Test-Path $cand)) {
        $resolved = (Resolve-Path $cand).Path
        if (Test-Path (Join-Path $resolved "EMPLOYEE_IDENTITY.csv")) {
            $resolvedDataset = $resolved
            break
        }
    }
}
if (-not $resolvedDataset) {
    if (Test-Path $DatasetDir) {
        $resolvedDataset = (Resolve-Path $DatasetDir).Path
    } else {
        $resolvedDataset = Join-Path $scriptDir $DatasetDir
    }
}

Write-Host "Connecting to Azure SQL: $SqlServer / $Database ..." -ForegroundColor Cyan
Write-Host "Dataset Directory: $resolvedDataset" -ForegroundColor Gray
$token = az account get-access-token --resource "https://database.windows.net/" --query accessToken -o tsv
if (-not $token) { throw "Unable to acquire Azure SQL access token. Run 'az login'." }

function Invoke-RpQuery([string]$query) {
    Invoke-Sqlcmd -ServerInstance $SqlServer -Database $Database -AccessToken $token -Query $query -ErrorAction Stop
}

# 1. Verify Dataset Files Exist
$requiredFiles = @(
    "EMPLOYEE_IDENTITY.csv",
    "BUSINESS_ROLE_MASTER.csv",
    "APPLICATION_MASTER.csv",
    "ENTITLEMENT_CATALOG.csv",
    "ROLE_ENTITLEMENTS.csv",
    "ROLE_ASSIGNMENTS.csv",
    "JML_EVENTS.csv",
    "ACCESS_REQUEST_TICKETS.csv"
)

foreach ($f in $requiredFiles) {
    $path = Join-Path $resolvedDataset $f
    if (-not (Test-Path $path)) { throw "Missing required dataset file: $path" }
}

Write-Host "All 8 dataset files verified in $resolvedDataset." -ForegroundColor Green

# 2. Adjust Table Column Sizes to Support GID (7 chars) and BR (6 chars)
Write-Host "Updating schema column sizes for dataset compatibility..." -ForegroundColor Cyan
$schemaAdjustSql = @"
IF EXISTS (SELECT 1 FROM sys.columns WHERE object_id = OBJECT_ID('src.Employee') AND name = 'EmployeeId' AND max_length < 16)
BEGIN
    -- Drop constraints referencing EmployeeId
    ALTER TABLE src.Role DROP CONSTRAINT IF EXISTS FK__Role__OwnerEmplo__2BFE89A6;
    ALTER TABLE src.Role ALTER COLUMN OwnerEmployeeId varchar(16) NOT NULL;
    ALTER TABLE src.Employee ALTER COLUMN EmployeeId varchar(16) NOT NULL;
    ALTER TABLE src.Move ALTER COLUMN EmployeeId varchar(16) NOT NULL;
    ALTER TABLE src.Assignment ALTER COLUMN EmployeeId varchar(16) NOT NULL;
    ALTER TABLE src.Ticket ALTER COLUMN EmployeeId varchar(16) NOT NULL;
    ALTER TABLE src.IdentityMap ALTER COLUMN EmployeeId varchar(16) NOT NULL;
    ALTER TABLE core.Principal ALTER COLUMN EmployeeId varchar(16) NOT NULL;
    ALTER TABLE core.Permission ALTER COLUMN EmployeeId varchar(16) NOT NULL;
    ALTER TABLE core.Member ALTER COLUMN EmployeeId varchar(16) NOT NULL;
    ALTER TABLE core.Evidence ALTER COLUMN EmployeeId varchar(16) NOT NULL;
    ALTER TABLE core.Transfer ALTER COLUMN EmployeeId varchar(16) NOT NULL;
    ALTER TABLE casework.ReviewCase ALTER COLUMN EmployeeId varchar(16) NOT NULL;
    ALTER TABLE casework.ReviewCase ALTER COLUMN OwnerEmployeeId varchar(16) NOT NULL;
    ALTER TABLE casework.Decision ALTER COLUMN Actor varchar(16) NOT NULL;
END
"@
Invoke-RpQuery $schemaAdjustSql

# 3. Clean Target Staging Tables
Write-Host "Truncating / resetting src tables..." -ForegroundColor Cyan
Invoke-RpQuery @"
DELETE FROM src.Ticket;
DELETE FROM src.Move;
DELETE FROM src.Assignment;
DELETE FROM src.RoleEntitlement;
DELETE FROM src.RoleVersion;
DELETE FROM src.Role;
DELETE FROM src.ExpectedMember;
DELETE FROM src.Origin;
DELETE FROM src.Exception;
DELETE FROM src.Coverage;
DELETE FROM src.IdentityMap;
DELETE FROM src.Employee;
DELETE FROM src.GroupMap;
DELETE FROM src.Entitlement;
"@

# Helper to escape SQL strings
function Escape-Sql([string]$str) {
    if ($null -eq $str) { return "NULL" }
    return "'" + $str.Replace("'", "''") + "'"
}

# 4. Ingest EMPLOYEE_IDENTITY.csv -> src.Employee (500 rows)
Write-Host "Ingesting EMPLOYEE_IDENTITY.csv (500 employees)..." -ForegroundColor Cyan
$empCsv = Import-Csv (Join-Path $DatasetDir "EMPLOYEE_IDENTITY.csv")
$empBatches = @()
foreach ($e in $empCsv) {
    $empId = $e.GID
    $dispName = "$($e.'First Name') $($e.'Last Name')"
    $email = $e.Email
    $active = if ($e.'Active Status' -eq 'Active') { 1 } else { 0 }
    $empBatches += "INSERT INTO src.Employee (EmployeeId, DisplayName, Email, Active) VALUES ($(Escape-Sql $empId), $(Escape-Sql $dispName), $(Escape-Sql $email), $active);"
    if ($empBatches.Count -ge 100) {
        Invoke-RpQuery ($empBatches -join "`n")
        $empBatches = @()
    }
}
if ($empBatches.Count -gt 0) { Invoke-RpQuery ($empBatches -join "`n") }

# 5. Ingest APPLICATION_MASTER.csv & ENTITLEMENT_CATALOG.csv -> src.Entitlement (250 rows)
Write-Host "Ingesting ENTITLEMENT_CATALOG.csv (250 entitlements)..." -ForegroundColor Cyan
$entCsv = Import-Csv (Join-Path $DatasetDir "ENTITLEMENT_CATALOG.csv")
$entApp = @{}
foreach ($e in $entCsv) { $entApp[$e.Entitlement_ID] = $e.Application_ID }
$entBatches = @()
foreach ($ent in $entCsv) {
    $entId = $ent.Entitlement_ID
    $disp = $ent.Entitlement_Name
    $risk = switch ($ent.Access_Level) {
        'Read' { 'Low' }
        'Standard' { 'Medium' }
        'Elevated' { 'High' }
        'Administrative' { 'High' }
        default { 'Medium' }
    }
    $ctx = $ent.Application_ID
    $entBatches += "INSERT INTO src.Entitlement (EntitlementId, DisplayName, Risk, ContextCode) VALUES ($(Escape-Sql $entId), $(Escape-Sql $disp), $(Escape-Sql $risk), $(Escape-Sql $ctx));"
    if ($entBatches.Count -ge 100) {
        Invoke-RpQuery ($entBatches -join "`n")
        $entBatches = @()
    }
}
if ($entBatches.Count -gt 0) { Invoke-RpQuery ($entBatches -join "`n") }

# 6. Ingest BUSINESS_ROLE_MASTER.csv -> src.Role & src.RoleVersion (75 rows)
Write-Host "Ingesting BUSINESS_ROLE_MASTER.csv (75 roles)..." -ForegroundColor Cyan
$roleCsv = Import-Csv (Join-Path $DatasetDir "BUSINESS_ROLE_MASTER.csv")
$roleBatches = @()
$verBatches = @()
foreach ($r in $roleCsv) {
    $roleId = $r.Business_Role_ID
    $title = $r.Title
    $cc = $r.Cost_Center
    $country = switch ($r.Business_Group) {
        'GM Financial US' { 'US' }
        'GM Financial Canada' { 'CA' }
        'GM Financial Mexico' { 'MX' }
        default { 'US' }
    }
    $owner = $r.Role_Owner_GID
    $roleBatches += "INSERT INTO src.Role (RoleId, JobTitle, CostCenter, Country, OwnerEmployeeId) VALUES ($(Escape-Sql $roleId), $(Escape-Sql $title), $(Escape-Sql $cc), '$country', $(Escape-Sql $owner));"
    
    $verId = "RV_${roleId}_1"
    $verBatches += "INSERT INTO src.RoleVersion (VersionId, RoleId, ValidFrom, ValidTo) VALUES ('$verId', $(Escape-Sql $roleId), '2025-01-01', NULL);"
}
Invoke-RpQuery ($roleBatches -join "`n")
Invoke-RpQuery ($verBatches -join "`n")

# 7. Ingest ROLE_ENTITLEMENTS.csv -> src.RoleEntitlement (900 rows)
Write-Host "Ingesting ROLE_ENTITLEMENTS.csv (900 role entitlements)..." -ForegroundColor Cyan
$reCsv = Import-Csv (Join-Path $DatasetDir "ROLE_ENTITLEMENTS.csv")
$reBatches = @()
foreach ($re in $reCsv) {
    if ($re.Present_In_Role_Flag -eq 'Y') {
        $verId = "RV_$($re.Business_Role_ID)_1"
        $entId = $re.Entitlement_ID
        $reBatches += "INSERT INTO src.RoleEntitlement (VersionId, EntitlementId) VALUES ('$verId', $(Escape-Sql $entId));"
        if ($reBatches.Count -ge 100) {
            Invoke-RpQuery ($reBatches -join "`n")
            $reBatches = @()
        }
    }
}
if ($reBatches.Count -gt 0) { Invoke-RpQuery ($reBatches -join "`n") }

# 8. Ingest ROLE_ASSIGNMENTS.csv -> src.Assignment (650 rows)
Write-Host "Ingesting ROLE_ASSIGNMENTS.csv (650 assignments)..." -ForegroundColor Cyan
$asnCsv = Import-Csv (Join-Path $DatasetDir "ROLE_ASSIGNMENTS.csv")
$asnBatches = @()
foreach ($a in $asnCsv) {
    $empId = $a.GID
    $verId = "RV_$($a.Business_Role_ID)_1"
    $vFrom = $a.Effective_From
    $vTo = if ([string]::IsNullOrWhiteSpace($a.Effective_To)) { "NULL" } else { Escape-Sql $a.Effective_To }
    $status = $a.Assignment_Status
    $asnBatches += "INSERT INTO src.Assignment (EmployeeId, VersionId, ValidFrom, ValidTo, AssignmentStatus) VALUES ($(Escape-Sql $empId), '$verId', '$vFrom', $vTo, $(Escape-Sql $status));"
    if ($asnBatches.Count -ge 100) {
        Invoke-RpQuery ($asnBatches -join "`n")
        $asnBatches = @()
    }
}
if ($asnBatches.Count -gt 0) { Invoke-RpQuery ($asnBatches -join "`n") }

# 9. Ingest JML_EVENTS.csv -> src.Move (175 events)
Write-Host "Ingesting JML_EVENTS.csv (175 JML events)..." -ForegroundColor Cyan
$jmlCsv = Import-Csv (Join-Path $DatasetDir "JML_EVENTS.csv")
$moveBatches = @()
foreach ($m in $jmlCsv) {
    $eventId = $m.JML_Event_ID
    $empId = $m.GID
    $fromVer = if ([string]::IsNullOrWhiteSpace($m.Previous_Business_Role_ID)) { "RV_NEW_HIRE" } else { "RV_$($m.Previous_Business_Role_ID)_1" }
    $toVer   = if ([string]::IsNullOrWhiteSpace($m.New_Business_Role_ID)) { "RV_LEAVER" } else { "RV_$($m.New_Business_Role_ID)_1" }
    $eff = $m.Event_Date
    
    # Ensure dummy versions exist if Joiner/Leaver
    if ($fromVer -eq "RV_NEW_HIRE") {
        Invoke-RpQuery "IF NOT EXISTS (SELECT 1 FROM src.Role WHERE RoleId = 'NEW_HIRE') BEGIN INSERT INTO src.Role VALUES ('NEW_HIRE', 'New Hire', '000', 'US', $(Escape-Sql $empId)); INSERT INTO src.RoleVersion VALUES ('RV_NEW_HIRE', 'NEW_HIRE', '2020-01-01', NULL); END"
    }
    if ($toVer -eq "RV_LEAVER") {
        Invoke-RpQuery "IF NOT EXISTS (SELECT 1 FROM src.Role WHERE RoleId = 'LEAVER') BEGIN INSERT INTO src.Role VALUES ('LEAVER', 'Leaver', '000', 'US', $(Escape-Sql $empId)); INSERT INTO src.RoleVersion VALUES ('RV_LEAVER', 'LEAVER', '2020-01-01', NULL); END"
    }
    
    $moveBatches += "INSERT INTO src.Move (EventId, EmployeeId, FromVersion, ToVersion, EffectiveAt) VALUES ($(Escape-Sql $eventId), $(Escape-Sql $empId), '$fromVer', '$toVer', '$eff');"
    if ($moveBatches.Count -ge 100) {
        Invoke-RpQuery ($moveBatches -join "`n")
        $moveBatches = @()
    }
}
if ($moveBatches.Count -gt 0) { Invoke-RpQuery ($moveBatches -join "`n") }

# 10. Ingest ACCESS_REQUEST_TICKETS.csv -> src.Ticket (600 rows)
Write-Host "Ingesting ACCESS_REQUEST_TICKETS.csv (600 tickets)..." -ForegroundColor Cyan
$tktCsv = Import-Csv (Join-Path $DatasetDir "ACCESS_REQUEST_TICKETS.csv")
$tktBatches = @()
foreach ($t in $tktCsv) {
    $tktId = $t.Ticket_ID
    $empId = $t.GID
    $opened = $t.Request_Date
    $resolved = if ([string]::IsNullOrWhiteSpace($t.Resolution_Date)) { "NULL" } else { Escape-Sql $t.Resolution_Date }
    $tType = $t.Request_Type
    $entId = if ([string]::IsNullOrWhiteSpace($t.Entitlement_ID)) { "NULL" } else { Escape-Sql $t.Entitlement_ID }
    $root = $tktId # Canonical root defaults to self
    $method = "Structured"
    # Ticket context must be the requested entitlement's application, so the engine can verify entitlement/context agreement.
    $ctx = if ($entApp.ContainsKey($t.Entitlement_ID)) { $entApp[$t.Entitlement_ID] } else { $t.Business_Role_ID }
    $text = "Manual access request for $($t.Entitlement_ID) under role $($t.Business_Role_ID). Priority: $($t.Priority). Auto-assigned expected: $($t.Auto_Assigned_Expected)."
    
    $tktBatches += "INSERT INTO src.Ticket (TicketId, EmployeeId, OpenedAt, ResolvedAt, TicketType, TicketText, EntitlementId, CanonicalRoot, MatchMethod, ContextCode) VALUES ($(Escape-Sql $tktId), $(Escape-Sql $empId), '$opened', $resolved, $(Escape-Sql $tType), $(Escape-Sql $text), $entId, $(Escape-Sql $root), '$method', $(Escape-Sql $ctx));"
    if ($tktBatches.Count -ge 100) {
        Invoke-RpQuery ($tktBatches -join "`n")
        $tktBatches = @()
    }
}
if ($tktBatches.Count -gt 0) { Invoke-RpQuery ($tktBatches -join "`n") }

# 11. Populate SourceStatus
Invoke-RpQuery @"
DELETE FROM src.SourceStatus;
INSERT INTO src.SourceStatus (DomainName, Complete, CheckedAt) VALUES ('HR', 1, SYSUTCDATETIME());
INSERT INTO src.SourceStatus (DomainName, Complete, CheckedAt) VALUES ('Roles', 1, SYSUTCDATETIME());
INSERT INTO src.SourceStatus (DomainName, Complete, CheckedAt) VALUES ('Tickets', 1, SYSUTCDATETIME());
"@

Write-Host "--- Hackathon Dataset Ingestion Summary ---" -ForegroundColor Green
$summary = Invoke-RpQuery @"
SELECT 'Employees' Entity, COUNT(*) [Count] FROM src.Employee
UNION ALL SELECT 'Roles', COUNT(*) FROM src.Role
UNION ALL SELECT 'Entitlements', COUNT(*) FROM src.Entitlement
UNION ALL SELECT 'RoleEntitlements', COUNT(*) FROM src.RoleEntitlement
UNION ALL SELECT 'Assignments', COUNT(*) FROM src.Assignment
UNION ALL SELECT 'Moves', COUNT(*) FROM src.Move
UNION ALL SELECT 'Tickets', COUNT(*) FROM src.Ticket;
"@
$summary | Format-Table -AutoSize
Write-Host "Hackathon dataset ingestion completed successfully!" -ForegroundColor Green
