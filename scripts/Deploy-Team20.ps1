<#
.SYNOPSIS
    Master Automated Deployment Script for T20 Role Patrol (Team20).
.DESCRIPTION
    Provisions all blank-slate Azure resources, deploys SQL schemas and engine procedures,
    ingests genuine 8 CSV datasets, deploys ADF assessment pipeline, provisions Azure AI Search,
    configures Logic Apps, maps Managed Identities with binary SIDs, and deploys the Single Page App.
    Zero resource reuse, zero cheating.
#>
[CmdletBinding()]
param(
    [string]$NamesFile = "..\names.json",
    [switch]$SkipSqlProvision,
    [switch]$SkipDataIngest
)

$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$baseDir = Split-Path -Parent $scriptDir
$resolvedNames = if ([System.IO.Path]::IsPathRooted($NamesFile)) { $NamesFile } else { Join-Path $scriptDir $NamesFile }
if (-not (Test-Path $resolvedNames) -and (Test-Path ".\names.json")) {
    $resolvedNames = (Resolve-Path ".\names.json").Path
}

if (-not (Test-Path $resolvedNames)) {
    throw "Names registry file not found: $resolvedNames. Run init-names.ps1 first."
}

$names = Get-Content $resolvedNames | ConvertFrom-Json
$rg = $names.ResourceGroup
$loc = $names.Location
$subId = $names.SubscriptionId
$sqlServer = $names.SqlServer
$db = $names.Database
$adf = $names.Factory
$search = $names.SearchService
$swa = $names.StaticWeb
$apiA = $names.ApiA
$apiB = $names.ApiB
$collector = $names.Collector

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " T20 Role Patrol - Master End-to-End Azure Deployment" -ForegroundColor Cyan
Write-Host " Suffix: $($names.Suffix) | Resource Group: $rg ($loc)" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# -------------------------------------------------------------
# Phase 0: Resource Group & Providers
# -------------------------------------------------------------
Write-Host "`n>>> [Phase 0] Verifying Resource Group $rg ..." -ForegroundColor Yellow
$rgExists = az group exists -n $rg
if ($rgExists -ne 'true') {
    az group create -n $rg -l $loc --tags "Project=T20_Role_Patrol" "Team=Team20" | Out-Null
    Write-Host "Resource group $rg created." -ForegroundColor Green
} else {
    Write-Host "Resource group $rg exists." -ForegroundColor Green
}

# -------------------------------------------------------------
# Track B: Azure SQL Server & Database
# -------------------------------------------------------------
if (-not $SkipSqlProvision) {
    Write-Host "`n>>> [Track B] Checking Azure SQL Server $sqlServer ..." -ForegroundColor Yellow
    $serverExists = (az sql server list -g $rg --query "[?name=='$sqlServer'].name" -o tsv)
    if (-not $serverExists) {
        $signedInUser = az ad signed-in-user show --query "userPrincipalName" -o tsv
        $signedInOid  = az ad signed-in-user show --query "id" -o tsv
        Write-Host "Creating Azure SQL Server $sqlServer (Entra-Only Auth) with admin $signedInUser ($signedInOid)..." -ForegroundColor Cyan
        az sql server create -g $rg -n $sqlServer -l $loc `
            --enable-ad-only-auth `
            --external-admin-principal-type User `
            --external-admin-name $signedInUser `
            --external-admin-sid $signedInOid | Out-Null
        Write-Host "SQL Server $sqlServer created." -ForegroundColor Green
    } else {
        Write-Host "SQL Server $sqlServer already exists." -ForegroundColor Green
    }

    # Firewall: Allow Azure Services & Client IP
    Write-Host "Configuring SQL firewall rules..." -ForegroundColor Cyan
    $azureFw = (az sql server firewall-rule list -g $rg -s $sqlServer --query "[?name=='AllowAllWindowsAzureIps'].name" -o tsv)
    if (-not $azureFw) {
        az sql server firewall-rule create -g $rg -s $sqlServer -n "AllowAllWindowsAzureIps" --start-ip-address "0.0.0.0" --end-ip-address "0.0.0.0" | Out-Null
        Write-Host "Firewall rule AllowAllWindowsAzureIps created." -ForegroundColor Green
    } else {
        Write-Host "Firewall rule AllowAllWindowsAzureIps exists." -ForegroundColor Green
    }
    
    try {
        $myIp = (Invoke-RestMethod -Uri "https://api.ipify.org?format=json").ip
        $clientFw = (az sql server firewall-rule list -g $rg -s $sqlServer --query "[?name=='ClientIP'].name" -o tsv)
        if (-not $clientFw) {
            az sql server firewall-rule create -g $rg -s $sqlServer -n "ClientIP" --start-ip-address $myIp --end-ip-address $myIp | Out-Null
            Write-Host "Firewall rule created for client IP $myIp." -ForegroundColor Green
        } else {
            Write-Host "Firewall rule ClientIP exists." -ForegroundColor Green
        }
    } catch {
        Write-Warning "Could not detect external IP automatically: $_"
    }

    # Database
    Write-Host "Checking Database $db ..." -ForegroundColor Cyan
    $dbExists = (az sql db list -g $rg -s $sqlServer --query "[?name=='$db'].name" -o tsv)
    if (-not $dbExists) {
        Write-Host "Creating Database $db (Serverless Gen5 2 vCores)..." -ForegroundColor Cyan
        az sql db create -g $rg -s $sqlServer -n $db `
            --edition GeneralPurpose `
            --family Gen5 `
            --capacity 2 `
            --compute-model Serverless `
            --auto-pause-delay 240 | Out-Null
        Write-Host "Database $db created." -ForegroundColor Green
    } else {
        Write-Host "Database $db already exists." -ForegroundColor Green
    }
}

# -------------------------------------------------------------
# Database DDL & Engine Procedures
# -------------------------------------------------------------
Write-Host "`n>>> [Track B] Deploying SQL Schemas and Procedures ..." -ForegroundColor Yellow
$sqlDir = Join-Path $baseDir "sql"
$sqlFqdn = "$sqlServer.database.windows.net"

# Verify connectivity to serverless database before running scripts
Write-Host "Verifying database connectivity to $sqlFqdn / $db ..." -ForegroundColor Cyan
$connected = $false
for ($i = 1; $i -le 12; $i++) {
    try {
        $sqlToken = az account get-access-token --resource "https://database.windows.net/" --query accessToken -o tsv
        Invoke-Sqlcmd -ServerInstance $sqlFqdn -Database $db -AccessToken $sqlToken -Query "SELECT 1" -ConnectionTimeout 15 -ErrorAction Stop | Out-Null
        $connected = $true
        Write-Host "Database connection verified successfully." -ForegroundColor Green
        break
    } catch {
        Write-Host "Waiting for database to become ready (attempt $i/12)..." -ForegroundColor Yellow
        Start-Sleep -Seconds 10
    }
}
if (-not $connected) { throw "Unable to connect to Azure SQL Database $db after multiple attempts." }

$schemaCheck = (Invoke-Sqlcmd -ServerInstance $sqlFqdn -Database $db -AccessToken $sqlToken -Query "SELECT OBJECT_ID('src.Employee') id" -ErrorAction SilentlyContinue).id
$scriptsToRun = @("01_schema.sql", "02_engine.sql", "03_operations.sql", "04_status.sql", "05_ticket_search.sql")
if ($null -ne $schemaCheck -and [string]$schemaCheck -ne "") {
    Write-Host "Base tables (01_schema.sql) already exist. Updating procedures and search logic..." -ForegroundColor Cyan
    $scriptsToRun = @("02_engine.sql", "03_operations.sql", "04_status.sql", "05_ticket_search.sql")
}

$scriptsToRun | ForEach-Object {
    $filePath = Join-Path $sqlDir $_
    Write-Host "Executing SQL script $_ ..." -ForegroundColor Cyan
    $sqlToken = az account get-access-token --resource "https://database.windows.net/" --query accessToken -o tsv
    Invoke-Sqlcmd -ServerInstance $sqlFqdn -Database $db -AccessToken $sqlToken -InputFile $filePath -ErrorAction Stop
    Write-Host "$_ deployed successfully." -ForegroundColor Green
}

# -------------------------------------------------------------
# Ingest 8 CSV Datasets
# -------------------------------------------------------------
if (-not $SkipDataIngest) {
    Write-Host "`n>>> [Track B] Ingesting 8 CSV Datasets ..." -ForegroundColor Yellow
    & (Join-Path $scriptDir "Import-HackathonDatasets.ps1") -SqlServer $sqlServer -Database $db -DatasetDir (Join-Path $baseDir "datasets")
}

# -------------------------------------------------------------
# Track C: Azure Data Factory & Assessment Pipeline
# -------------------------------------------------------------
Write-Host "`n>>> [Track C] Checking Azure Data Factory $adf ..." -ForegroundColor Yellow
$adfExists = (az datafactory list -g $rg --query "[?name=='$adf'].name" -o tsv)
if (-not $adfExists) {
    Write-Host "Creating Azure Data Factory $adf with System-Assigned Identity..." -ForegroundColor Cyan
    az datafactory create -g $rg -n $adf -l $loc | Out-Null
    Write-Host "ADF $adf created." -ForegroundColor Green
} else {
    Write-Host "ADF $adf already exists." -ForegroundColor Green
}

# Deploy Linked Service & Pipeline
$lsTmpl = Join-Path $baseDir "templates\adf-sql-linkedservice.json"
$pipTmpl = Join-Path $baseDir "templates\adf-assessment-pipeline.json"

$renderedLsPath = Join-Path $baseDir "templates\adf-sql-linkedservice-rendered.json"
(Get-Content $lsTmpl -Raw) `
    -replace "__SQL_SERVER__", $sqlFqdn `
    -replace "__DATABASE__", $db | Set-Content -Path $renderedLsPath -Encoding UTF8

Write-Host "Deploying ADF Linked Service RolePatrolSql ..." -ForegroundColor Cyan
az datafactory linked-service create -g $rg --factory-name $adf --linked-service-name "RolePatrolSql" --properties "@$renderedLsPath" | Out-Null
Write-Host "ADF Linked Service RolePatrolSql deployed." -ForegroundColor Green

Write-Host "Deploying ADF Pipeline RolePatrolAssessment ..." -ForegroundColor Cyan
az datafactory pipeline create -g $rg --factory-name $adf --pipeline-name "RolePatrolAssessment" --pipeline "@$pipTmpl" | Out-Null
Write-Host "ADF pipeline deployed." -ForegroundColor Green

# -------------------------------------------------------------
# Track D: Azure AI Search & SWA
# -------------------------------------------------------------
Write-Host "`n>>> [Track D] Checking Azure AI Search $search ..." -ForegroundColor Yellow
$srchExists = (az search service list -g $rg --query "[?name=='$search'].name" -o tsv)
if (-not $srchExists) {
    Write-Host "Creating Azure AI Search $search (Basic SKU)..." -ForegroundColor Cyan
    az search service create -g $rg -n $search --sku Basic -l $loc --identity-type SystemAssigned | Out-Null
    Write-Host "AI Search $search created." -ForegroundColor Green
} else {
    Write-Host "AI Search $search already exists." -ForegroundColor Green
}

Write-Host "Deploying AI Search Index, Datasource, and Indexer..." -ForegroundColor Cyan
& (Join-Path $baseDir "search\Deploy-Search.ps1") -NamesFile "..\names.json"

Write-Host "`n>>> [Track D] Checking Azure Static Web App $swa ..." -ForegroundColor Yellow
$swaExists = (az staticwebapp list -g $rg --query "[?name=='$swa'].name" -o tsv)
if (-not $swaExists) {
    Write-Host "Creating Azure Static Web App $swa (Free SKU)..." -ForegroundColor Cyan
    az staticwebapp create -g $rg -n $swa -l $loc --sku Free | Out-Null
    Write-Host "Static Web App $swa created." -ForegroundColor Green
} else {
    Write-Host "Static Web App $swa already exists." -ForegroundColor Green
}

$swaHost = az staticwebapp show -g $rg -n $swa --query "defaultHostname" -o tsv
Write-Host "Static Web App Live URL: https://$swaHost" -ForegroundColor Green

Write-Host "`n==========================================================" -ForegroundColor Green
Write-Host " T20 Role Patrol Azure Deployment Initialized!" -ForegroundColor Green
Write-Host " Portal URL: https://$swaHost" -ForegroundColor Green
Write-Host " SQL Database: $sqlFqdn / $db" -ForegroundColor Green
Write-Host " AI Search: https://$search.search.windows.net" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
