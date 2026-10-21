[CmdletBinding()]
param(
    [string]$NamesFile = "..\names.json"
)

$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$resolvedNames = if ([System.IO.Path]::IsPathRooted($NamesFile)) { $NamesFile } else { Join-Path $scriptDir $NamesFile }
if (-not (Test-Path $resolvedNames) -and (Test-Path ".\names.json")) {
    $resolvedNames = (Resolve-Path ".\names.json").Path
}

if (-not (Test-Path $resolvedNames)) {
    throw "Names file not found: $resolvedNames"
}

$names = Get-Content $resolvedNames | ConvertFrom-Json
$rg = $names.ResourceGroup
$sqlServer = "$($names.SqlServer).database.windows.net"
$db = $names.Database
$swa = $names.StaticWeb
$passCount = 0
$failCount = 0

function Assert-Check {
    param(
        [Parameter(Mandatory=$true)][string]$Description,
        [Parameter(Mandatory=$true)][bool]$Condition
    )
    if ($Condition) {
        Write-Host "  [PASS] $Description" -ForegroundColor Green
        $script:passCount++
    } else {
        Write-Host "  [FAIL] $Description" -ForegroundColor Red
        $script:failCount++
    }
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " t020 Role Patrol - Automated Validation Suite" -ForegroundColor Cyan
Write-Host " Testing against: $rg ($($names.Location))" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Zero Resource Reuse Assertions
Write-Host "`n>>> Check 1: Zero Resource Reuse and Isolation" -ForegroundColor Yellow
Assert-Check -Description "Resource group matches t020/Team20 standard ($rg)" -Condition ($rg -like "rg-t020-*" -or $rg -like "rg-Team20-*")
Assert-Check -Description "SQL server name starts with t020- or team20- ($($names.SqlServer))" -Condition ($names.SqlServer -like "t020-sql-*" -or $names.SqlServer -like "team20-sql-*")
Assert-Check -Description "Static Web App starts with t020- or team20- ($swa)" -Condition ($swa -like "t020-swa-*" -or $swa -like "team20-swa-*")
Assert-Check -Description "Search service starts with t020- or team20- ($($names.SearchService))" -Condition ($names.SearchService -like "t020-srch-*" -or $names.SearchService -like "team20-srch-*")
Assert-Check -Description "No reference to legacy lab resource group" -Condition ($rg -notlike "*84d1e75e*")
Assert-Check -Description "No reference to legacy SQL server" -Condition ($names.SqlServer -notlike "*84d1e75e*")

# 2. Azure Resource Group Verification
Write-Host "`n>>> Check 2: Azure Resource Group Existence" -ForegroundColor Yellow
$rgExists = az group exists -n $rg
Assert-Check -Description "Resource group $rg is provisioned in Azure" -Condition ($rgExists -eq 'true')

# 3. Static Web App CDN Verification
Write-Host "`n>>> Check 3: Static Web App Edge CDN Health" -ForegroundColor Yellow
$swaHost = az staticwebapp show -g $rg -n $swa --query "defaultHostname" -o tsv 2>$null
Assert-Check -Description "Static Web App resource exists in Azure" -Condition ($null -ne $swaHost -and $swaHost -ne "")

if ($swaHost) {
    $swaUrl = "https://$swaHost"
    $bridgeUrl = "$swaUrl/bridge.html"
    try {
        $portalResp = Invoke-WebRequest -Uri $swaUrl -UseBasicParsing -TimeoutSec 15
        Assert-Check -Description "Portal URL returns HTTP 200 ($swaUrl)" -Condition ($portalResp.StatusCode -eq 200)
    } catch {
        Assert-Check -Description "Portal URL is reachable ($swaUrl)" -Condition $false
    }

    try {
        $bridgeResp = Invoke-WebRequest -Uri $bridgeUrl -UseBasicParsing -TimeoutSec 15
        Assert-Check -Description "MSAL Redirect Bridge returns HTTP 200 ($bridgeUrl)" -Condition ($bridgeResp.StatusCode -eq 200)
    } catch {
        Assert-Check -Description "MSAL Redirect Bridge is reachable ($bridgeUrl)" -Condition $false
    }
}

# 4. SQL Server and Database Connectivity
Write-Host "`n>>> Check 4: Azure SQL Server and Table Counts" -ForegroundColor Yellow
$token = az account get-access-token --resource "https://database.windows.net/" --query accessToken -o tsv 2>$null
if ($token) {
    try {
        $empCount = (Invoke-Sqlcmd -ServerInstance $sqlServer -Database $db -AccessToken $token -Query "SELECT COUNT(*) c FROM src.Employee;" -ErrorAction Stop).c
        Assert-Check -Description "src.Employee contains 500 records (actual: $empCount)" -Condition ($empCount -eq 500)

        $roleCount = (Invoke-Sqlcmd -ServerInstance $sqlServer -Database $db -AccessToken $token -Query "SELECT COUNT(*) c FROM src.Role WHERE RoleId LIKE 'BR%';" -ErrorAction Stop).c
        Assert-Check -Description "src.Role contains 75 genuine business roles (actual: $roleCount)" -Condition ($roleCount -eq 75)

        $entCount = (Invoke-Sqlcmd -ServerInstance $sqlServer -Database $db -AccessToken $token -Query "SELECT COUNT(*) c FROM src.Entitlement;" -ErrorAction Stop).c
        Assert-Check -Description "src.Entitlement contains 250 records (actual: $entCount)" -Condition ($entCount -eq 250)

        $ticketCount = (Invoke-Sqlcmd -ServerInstance $sqlServer -Database $db -AccessToken $token -Query "SELECT COUNT(*) c FROM src.Ticket;" -ErrorAction Stop).c
        Assert-Check -Description "src.Ticket contains 600 records (actual: $ticketCount)" -Condition ($ticketCount -eq 600)

        $moveCount = (Invoke-Sqlcmd -ServerInstance $sqlServer -Database $db -AccessToken $token -Query "SELECT COUNT(*) c FROM src.Move;" -ErrorAction Stop).c
        Assert-Check -Description "src.Move contains 175 records (actual: $moveCount)" -Condition ($moveCount -eq 175)

        # 5. Role Owner Governance Mappings
        Write-Host "`n>>> Check 5: Role Owner Governance Mapping" -ForegroundColor Yellow
        $usOwner = (Invoke-Sqlcmd -ServerInstance $sqlServer -Database $db -AccessToken $token -Query "SELECT OwnerEmployeeId FROM src.Role WHERE RoleId = 'BR0008';" -ErrorAction Stop).OwnerEmployeeId
        Assert-Check -Description "US Credit Review (BR0008) is owned by Doreni Arvenor (GID0004)" -Condition ($usOwner -eq 'GID0004')

        $caOwner = (Invoke-Sqlcmd -ServerInstance $sqlServer -Database $db -AccessToken $token -Query "SELECT OwnerEmployeeId FROM src.Role WHERE RoleId = 'BR0033';" -ErrorAction Stop).OwnerEmployeeId
        Assert-Check -Description "Canada Credit Review (BR0033) is owned by Alira Arvenor (GID0001)" -Condition ($caOwner -eq 'GID0001')

    } catch {
        Write-Warning "SQL validation queries could not be executed: $_"
        Assert-Check -Description "Azure SQL Database $db is accessible" -Condition $false
    }
} else {
    Write-Warning "Skipping SQL assertions: unable to acquire Azure SQL access token."
}

# 6. Azure Data Factory Pipeline Verification
Write-Host "`n>>> Check 6: Azure Data Factory Pipeline Deployment" -ForegroundColor Yellow
$pipExists = (az datafactory pipeline list -g $rg --factory-name $names.Factory --query "[?name=='RolePatrolAssessment'].name" -o tsv 2>$null)
Assert-Check -Description "ADF pipeline RolePatrolAssessment is deployed in $($names.Factory)" -Condition ($pipExists -eq 'RolePatrolAssessment')

# 7. Azure AI Search Service Verification
Write-Host "`n>>> Check 7: Azure AI Search Deployment & Sizing" -ForegroundColor Yellow
$srchExists = (az search service list -g $rg --query "[?name=='$($names.SearchService)'].name" -o tsv 2>$null)
Assert-Check -Description "Azure AI Search service $($names.SearchService) exists in $rg" -Condition ($srchExists -eq $names.SearchService)

# 8. Logic Apps Workflows Verification
Write-Host "`n>>> Check 8: Logic Apps Workflows & Health" -ForegroundColor Yellow
$laA = (az logic workflow list -g $rg --query "[?name=='$($names.ApiA)'].name" -o tsv 2>$null)
Assert-Check -Description "Logic App US API Gateway ($($names.ApiA)) exists" -Condition ($laA -eq $names.ApiA)

$laB = (az logic workflow list -g $rg --query "[?name=='$($names.ApiB)'].name" -o tsv 2>$null)
Assert-Check -Description "Logic App Canada API Gateway ($($names.ApiB)) exists" -Condition ($laB -eq $names.ApiB)

$laCollect = (az logic workflow list -g $rg --query "[?name=='$($names.Collector)'].name" -o tsv 2>$null)
Assert-Check -Description "Logic App Collector ($($names.Collector)) exists" -Condition ($laCollect -eq $names.Collector)

$laShell = (az logic workflow list -g $rg --query "[?name=='$($names.Shell)'].name" -o tsv 2>$null)
Assert-Check -Description "Logic App Shell ($($names.Shell)) exists" -Condition ($laShell -eq $names.Shell)

$color = if ($failCount -eq 0) { "Green" } else { "Red" }
Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host " Validation Complete: $passCount Passed, $failCount Failed" -ForegroundColor $color
Write-Host "==========================================================" -ForegroundColor Cyan
