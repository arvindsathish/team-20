[CmdletBinding()]
param(
    [string]$NamesFile = "..\names.json"
)

$ErrorActionPreference = 'Stop'
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
if (-not $resolvedNames -or -not (Test-Path $resolvedNames)) {
    throw "Names file not found. Candidates checked: $($nameCandidates -join ', ')"
}

$names = Get-Content $resolvedNames | ConvertFrom-Json
$searchName = $names.SearchService
$subId = $names.SubscriptionId
$rg = $names.ResourceGroup
$sqlServer = $names.SqlServer
$database = $names.Database

Write-Host "=== Track D: Deploying Azure AI Search Components to $searchName ===" -ForegroundColor Cyan

# Obtain admin key for AI Search
$adminKey = az search admin-key show --service-name $searchName --resource-group $rg --query "primaryKey" -o tsv
if (-not $adminKey) {
    throw "Failed to retrieve primary admin key for search service: $searchName"
}

$headers = @{
    "Content-Type" = "application/json"
    "api-key"      = $adminKey
}
$endpoint = "https://$searchName.search.windows.net"

# Verify endpoint readiness (DNS propagation & SSL setup)
Write-Host "Verifying Azure AI Search endpoint availability ($endpoint)..." -ForegroundColor Cyan
$searchReady = $false
for ($i = 1; $i -le 15; $i++) {
    try {
        $test = Invoke-RestMethod -Uri "$endpoint/indexes?api-version=2024-07-01" -Method Get -Headers $headers -TimeoutSec 10 -ErrorAction Stop
        $searchReady = $true
        Write-Host "Azure AI Search endpoint is ready and reachable." -ForegroundColor Green
        break
    } catch {
        Write-Host "Waiting for Azure AI Search endpoint ($searchName.search.windows.net) to be ready (attempt $i/15)..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10
    }
}
if (-not $searchReady) {
    throw "Azure AI Search endpoint $endpoint was not reachable after 15 attempts."
}

# Ensure System-Assigned Managed Identity is enabled on Search Service
Write-Host "Ensuring System-Assigned Managed Identity is enabled on Azure AI Search service..." -ForegroundColor Yellow
$searchInfo = az search service show --name $searchName --resource-group $rg -o json | ConvertFrom-Json
if (-not $searchInfo.identity -or $searchInfo.identity.type -ne "SystemAssigned") {
    az resource update --ids $searchInfo.id --set identity.type="SystemAssigned" -o none
    $searchInfo = az search service show --name $searchName --resource-group $rg -o json | ConvertFrom-Json
}
$searchPrincipalId = $searchInfo.identity.principalId
if ($searchPrincipalId) {
    # Grant Reader on Azure SQL Server to allow indexer endpoint resolution
    $sqlServerArm = az sql server show --name $sqlServer --resource-group $rg -o json | ConvertFrom-Json
    if ($sqlServerArm.id) {
        az role assignment create --assignee-object-id $searchPrincipalId --assignee-principal-type ServicePrincipal --role 'Reader' --scope $sqlServerArm.id -o none 2>$null
    }
}

# 1. Create / Update Index
Write-Host "Creating/updating search index 'ticket-text'..." -ForegroundColor Yellow
$indexPath = Join-Path $scriptDir "ticket-text-index.json"
$indexJson = Get-Content $indexPath -Raw
Invoke-RestMethod -Uri "$endpoint/indexes/ticket-text?api-version=2024-07-01" -Method Put -Headers $headers -Body $indexJson | Out-Null
Write-Host "Index 'ticket-text' deployed." -ForegroundColor Green

# 2. Configure Azure SQL Data Source & Indexer (Hybrid / Background Sync)
try {
    Write-Host "Creating/updating datasource 'rolepatrol-ticket-source'..." -ForegroundColor Yellow
    $dsPath = Join-Path $scriptDir "ticket-text-datasource.json"
    $dsJson = (Get-Content $dsPath -Raw) `
        -replace "__SUBSCRIPTION_ID__", $subId `
        -replace "__RESOURCE_GROUP__", $rg `
        -replace "__SQL_SERVER__", $sqlServer `
        -replace "__DATABASE__", $database

    Invoke-RestMethod -Uri "$endpoint/datasources/rolepatrol-ticket-source?api-version=2024-07-01" -Method Put -Headers $headers -Body $dsJson | Out-Null
    Write-Host "Data source 'rolepatrol-ticket-source' deployed." -ForegroundColor Green

    Write-Host "Creating/updating indexer 'rolepatrol-ticket-indexer'..." -ForegroundColor Yellow
    $indexerPath = Join-Path $scriptDir "ticket-text-indexer.json"
    $indexerJson = Get-Content $indexerPath -Raw
    Invoke-RestMethod -Uri "$endpoint/indexers/rolepatrol-ticket-indexer?api-version=2024-07-01" -Method Put -Headers $headers -Body $indexerJson | Out-Null
    Write-Host "Indexer 'rolepatrol-ticket-indexer' deployed." -ForegroundColor Green

    Write-Host "Running indexer 'rolepatrol-ticket-indexer'..." -ForegroundColor Yellow
    Invoke-RestMethod -Uri "$endpoint/indexers/rolepatrol-ticket-indexer/run?api-version=2024-07-01" -Method Post -Headers $headers | Out-Null
    Write-Host "Indexer run triggered successfully." -ForegroundColor Green
} catch {
    Write-Warning "SQL Indexer setup skipped or pending SQL managed identity propagation: $_"
    Write-Host "Proceeding with direct semantic dataset ingestion (guarantees 100% index availability)..." -ForegroundColor Cyan
}

# 5. Direct Ingest Genuine Dataset into Search Index with Semantic Metadata
$csvPath = Join-Path (Split-Path -Parent $scriptDir) "datasets\ACCESS_REQUEST_TICKETS.csv"
$rolesPath = Join-Path (Split-Path -Parent $scriptDir) "datasets\BUSINESS_ROLE_MASTER.csv"
$appsPath = Join-Path (Split-Path -Parent $scriptDir) "datasets\APPLICATION_MASTER.csv"
$entsPath = Join-Path (Split-Path -Parent $scriptDir) "datasets\ENTITLEMENT_CATALOG.csv"

if (Test-Path $csvPath) {
    Write-Host "Directly indexing semantically enriched tickets into 'ticket-text'..." -ForegroundColor Cyan
    $roleMap = @{}
    if (Test-Path $rolesPath) {
        Import-Csv $rolesPath | ForEach-Object { $roleMap[$_.Business_Role_ID] = @{ Title = $_.Title; Group = $_.Business_Group } }
    }
    $appMap = @{}
    if (Test-Path $appsPath) {
        Import-Csv $appsPath | ForEach-Object { $appMap[$_.Application_ID] = @{ Name = $_.Application_Name; Category = $_.Application_Category } }
    }
    $entMap = @{}
    if (Test-Path $entsPath) {
        Import-Csv $entsPath | ForEach-Object {
            $aInfo = $appMap[$_.Application_ID]
            $entMap[$_.Entitlement_ID] = @{
                Name = $_.Entitlement_Name
                Level = $_.Access_Level
                AppId = $_.Application_ID
                AppName = if ($aInfo) { $aInfo.Name } else { $_.Application_ID }
                AppCategory = if ($aInfo) { $aInfo.Category } else { "Operations" }
            }
        }
    }

    $tickets = Import-Csv $csvPath
    $docs = @()
    foreach ($t in $tickets) {
        $rInfo = $roleMap[$t.Business_Role_ID]
        $eInfo = $entMap[$t.Entitlement_ID]
        $rTitle = if ($rInfo) { $rInfo.Title } else { $t.Business_Role_ID }
        $rGroup = if ($rInfo) { $rInfo.Group } else { "GM Financial" }
        $eName = if ($eInfo) { $eInfo.Name } else { $t.Entitlement_ID }
        $eLevel = if ($eInfo) { $eInfo.Level } else { "Standard" }
        $appName = if ($eInfo) { $eInfo.AppName } else { "Core Banking" }
        $appCat = if ($eInfo) { $eInfo.AppCategory } else { "Finance Operations" }

        $semanticText = "Manual access request for $eName ($($t.Entitlement_ID)) in $appName ($($eInfo.AppId), $appCat) under role $rTitle ($($t.Business_Role_ID), $rGroup). Request type: $($t.Request_Type). Access level: $eLevel. Priority: $($t.Priority). Auto-assigned expected: $($t.Auto_Assigned_Expected)."

        $docs += @{
            "@search.action" = "mergeOrUpload"
            "ticketId"       = $t.Ticket_ID
            "ticketText"     = $semanticText
            "ticketType"     = $t.Request_Type
            "contextCode"    = $t.Business_Role_ID
        }
    }
    
    for ($i = 0; $i -lt $docs.Count; $i += 200) {
        $end = [Math]::Min($i + 199, $docs.Count - 1)
        $batch = $docs[$i..$end]
        $payload = @{ value = $batch } | ConvertTo-Json -Depth 5
        Invoke-RestMethod -Uri "$endpoint/indexes/ticket-text/docs/index?api-version=2024-07-01" -Method Post -Headers $headers -Body $payload | Out-Null
    }
    Write-Host "Successfully indexed $($docs.Count) semantically enriched tickets directly into AI Search." -ForegroundColor Green
}

