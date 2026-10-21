<#
.SYNOPSIS
    Deploy the 4 Logic Apps for T20 Role Patrol (Team20).
.DESCRIPTION
    Provisions Team20_la_collect_204508, Team20_la_api_a_204508, Team20_la_api_b_204508,
    and Team20_la_shell_204508 in rg-Team20-204508 with System-Assigned Managed Identities.
    Configures SQL users and principal mappings in team20_rolepatrol.
#>
[CmdletBinding()]
param(
    [string]$NamesFile = "..\names.json"
)

$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$baseDir = Split-Path -Parent $scriptDir
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
if (-not $resolvedNames -or -not (Test-Path $resolvedNames)) {
    throw "Names file not found: $NamesFile. Candidates checked: $($nameCandidates -join ', ')"
}

$names = Get-Content $resolvedNames | ConvertFrom-Json
$rg = $names.ResourceGroup
$loc = $names.Location
$sqlServer = "$($names.SqlServer).database.windows.net"
$db = $names.Database
$basicDef = Join-Path $baseDir "templates\basic-workflow.json"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " T20 Role Patrol - Logic Apps Deployment" -ForegroundColor Cyan
Write-Host " Target: $rg ($loc)" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$workflows = @(
    @{ Name = $names.Collector; Desc = "Entra ID Directory Collector" },
    @{ Name = $names.ApiA;      Desc = "US Lead API Gateway (GID0004)" },
    @{ Name = $names.ApiB;      Desc = "Canada Lead API Gateway (GID0001)" },
    @{ Name = $names.Shell;     Desc = "Administrative Shell Workflow" }
)

foreach ($item in $workflows) {
    $wf = $item.Name
    $desc = $item.Desc
    Write-Host "`n>>> Checking Logic App $wf ($desc)..." -ForegroundColor Yellow
    
    $exists = (az logic workflow list -g $rg --query "[?name=='$wf'].name" -o tsv)
    if (-not $exists) {
        Write-Host "Creating Logic App $wf..." -ForegroundColor Cyan
        az logic workflow create `
            --resource-group $rg `
            --location $loc `
            --name $wf `
            --state "Enabled" `
            --mi-system-assigned true `
            --definition "@$basicDef" | Out-Null
        Write-Host "Logic App $wf created with Managed Identity." -ForegroundColor Green
    } else {
        Write-Host "Logic App $wf already exists." -ForegroundColor Green
        # Ensure system assigned identity is enabled
        az logic workflow identity assign --resource-group $rg --name $wf --system-assigned 2>$null | Out-Null
    }
    
    $principalId = (az logic workflow show -g $rg -n $wf --query identity.principalId -o tsv)
    Write-Host "  Principal ID: $principalId" -ForegroundColor Gray
}

# -------------------------------------------------------------
# Grant Graph Permissions to Collector
# -------------------------------------------------------------
Write-Host "`n>>> Configuring Collector Graph API Permissions..." -ForegroundColor Yellow
try {
    $collectorPrincipalId = (az logic workflow show -g $rg -n $names.Collector --query identity.principalId -o tsv)
    $graphAppId = "00000003-0000-0000-c000-000000000000"
    $graphSp = az ad sp list --filter "appId eq '$graphAppId'" --output json | ConvertFrom-Json
    if ($graphSp) {
        $appRole = $graphSp.appRoles | Where-Object { $_.value -eq "GroupMember.Read.All" -and $_.allowedMemberTypes -contains "Application" } | Select-Object -First 1
        if ($appRole) {
            $existingAssignment = az rest --method GET --uri "https://graph.microsoft.com/v1.0/servicePrincipals/$collectorPrincipalId/appRoleAssignments" 2>$null | ConvertFrom-Json
            $alreadyAssigned = $existingAssignment.value | Where-Object { $_.appRoleId -eq $appRole.id }
            if (-not $alreadyAssigned) {
                az rest --method POST `
                    --uri "https://graph.microsoft.com/v1.0/servicePrincipals/$collectorPrincipalId/appRoleAssignments" `
                    --headers "Content-Type=application/json" `
                    --body (@{
                        principalId = $collectorPrincipalId
                        resourceId  = $graphSp.id
                        appRoleId   = $appRole.id
                    } | ConvertTo-Json) 2>$null | Out-Null
                Write-Host "Granted GroupMember.Read.All to Collector ($names.Collector)." -ForegroundColor Green
            } else {
                Write-Host "Collector already has GroupMember.Read.All." -ForegroundColor Green
            }
        }
    }
} catch {
    Write-Warning "Graph permission assignment skipped: $_"
}

# -------------------------------------------------------------
# Configure SQL Users & Principals for Logic Apps in team20_rolepatrol
# -------------------------------------------------------------
Write-Host "`n>>> Configuring Azure SQL Users & Principals in $db ..." -ForegroundColor Yellow
$token = az account get-access-token --resource "https://database.windows.net/" --query accessToken -o tsv
if ($token) {
    $adminUser = az ad signed-in-user show --query "userPrincipalName" -o tsv
    $sqlScript = @"
-- 1. Ensure Logic App users exist from external provider
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = '$($names.ApiA)')
    BEGIN TRY CREATE USER [$($names.ApiA)] FROM EXTERNAL PROVIDER; ALTER ROLE db_datareader ADD MEMBER [$($names.ApiA)]; ALTER ROLE db_datawriter ADD MEMBER [$($names.ApiA)]; GRANT EXECUTE TO [$($names.ApiA)]; END TRY BEGIN CATCH END CATCH;

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = '$($names.ApiB)')
    BEGIN TRY CREATE USER [$($names.ApiB)] FROM EXTERNAL PROVIDER; ALTER ROLE db_datareader ADD MEMBER [$($names.ApiB)]; ALTER ROLE db_datawriter ADD MEMBER [$($names.ApiB)]; GRANT EXECUTE TO [$($names.ApiB)]; END TRY BEGIN CATCH END CATCH;

-- 2. Map Principals in core.Principal
DELETE FROM core.Principal WHERE DbUser IN ('$($names.ApiA)', '$($names.ApiB)', 'dbo', '$adminUser');
INSERT INTO core.Principal (EmployeeId, DbUser) VALUES ('GID0004', '$($names.ApiA)');
INSERT INTO core.Principal (EmployeeId, DbUser) VALUES ('GID0001', '$($names.ApiB)');
INSERT INTO core.Principal (EmployeeId, DbUser) VALUES ('GID0004', 'dbo');
IF ('$adminUser' <> 'dbo')
    INSERT INTO core.Principal (EmployeeId, DbUser) VALUES ('GID0004', '$adminUser');

-- 3. Seed Role Owner Permissions
DELETE FROM core.Permission WHERE EmployeeId IN ('GID0004', 'GID0001');
INSERT INTO core.Permission (EmployeeId, RoleId, CanReadDetail, CanDecide, CanIam)
SELECT 'GID0004', RoleId, 1, 1, 1 FROM src.Role WHERE OwnerEmployeeId = 'GID0004';

INSERT INTO core.Permission (EmployeeId, RoleId, CanReadDetail, CanDecide, CanIam)
SELECT 'GID0001', RoleId, 1, 1, 1 FROM src.Role WHERE OwnerEmployeeId = 'GID0001';
"@

    $tempSql = Join-Path $baseDir "sql\logic_app_users.sql"
    Set-Content -Path $tempSql -Value $sqlScript -Encoding UTF8
    Invoke-Sqlcmd -ServerInstance $sqlServer -Database $db -AccessToken $token -InputFile $tempSql -ErrorAction Stop
    Write-Host "SQL Principals and Permissions provisioned for GID0004 and GID0001." -ForegroundColor Green
}

# -------------------------------------------------------------
# Trigger Callback URLs
# -------------------------------------------------------------
Write-Host "`n>>> Querying Trigger Endpoints..." -ForegroundColor Yellow
foreach ($item in $workflows) {
    $wf = $item.Name
    try {
        $cb = az rest --method post --uri "/subscriptions/$($names.SubscriptionId)/resourceGroups/$rg/providers/Microsoft.Logic/workflows/$wf/triggers/manual/listCallbackUrl?api-version=2016-06-01" 2>$null | ConvertFrom-Json
        if ($cb.value) {
            $cleanUrl = $cb.value.Split('?')[0]
            Write-Host "  $wf Endpoint: $cleanUrl" -ForegroundColor Cyan
        }
    } catch {
        Write-Warning "Could not retrieve trigger callback for $wf."
    }
}

Write-Host "`n==========================================================" -ForegroundColor Green
Write-Host " Logic Apps Deployment Completed Successfully!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
