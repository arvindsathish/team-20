<#
.SYNOPSIS
    Provisions Microsoft Entra ID users and security groups matching the Hackathon datasets.
.DESCRIPTION
    Reads EMPLOYEE_IDENTITY.csv and ENTITLEMENT_CATALOG.csv to create corresponding
    Entra ID users and security groups, and outputs identity-map.sql for Azure SQL.
#>
[CmdletBinding()]
param(
    [string]$VerifiedDomain,
    [string]$NamesFile = "..\names.json",
    [string]$OutputDirectory = "..\directory-output",
    [string]$DatasetDir = "..\datasets"
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
    $prefix = $names.Prefix
} else {
    $prefix = "t020_36de74"
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

$resolvedOutput = $null
if ([System.IO.Path]::IsPathRooted($OutputDirectory)) {
    $resolvedOutput = $OutputDirectory
} elseif (Test-Path (Join-Path $PWD $OutputDirectory)) {
    $resolvedOutput = (Resolve-Path (Join-Path $PWD $OutputDirectory)).Path
} elseif (Test-Path (Join-Path (Split-Path -Parent $scriptDir) $OutputDirectory)) {
    $resolvedOutput = (Resolve-Path (Join-Path (Split-Path -Parent $scriptDir) $OutputDirectory)).Path
} else {
    $resolvedOutput = Join-Path (Split-Path -Parent $scriptDir) $OutputDirectory
}

$account = az account show -o json | ConvertFrom-Json
if (-not $account.id) { throw "No active Azure CLI session found. Run 'az login'." }

if (-not $VerifiedDomain) {
    $domains = az rest --method get --url "https://graph.microsoft.com/v1.0/domains" --output json | ConvertFrom-Json
    $VerifiedDomain = ($domains.value | Where-Object { $_.isDefault -eq $true }).id
    if (-not $VerifiedDomain) {
        $VerifiedDomain = ($domains.value | Select-Object -First 1).id
    }
}
Write-Host "Using Verified Domain: $VerifiedDomain" -ForegroundColor Green
Write-Host "Using Prefix: $prefix" -ForegroundColor Green

$token = az account get-access-token --resource-type ms-graph --query accessToken -o tsv
if (-not $token) { throw "Failed to acquire Microsoft Graph token." }
$headers = @{ Authorization = "Bearer $token" }

function Graph([string]$Method, [string]$Path, $Body) {
    $p = @{ Method = $Method; Uri = "https://graph.microsoft.com/v1.0/$Path"; Headers = $headers; ErrorAction = 'Stop' }
    if ($null -ne $Body) {
        $p.ContentType = 'application/json'
        $p.Body = ($Body | ConvertTo-Json -Depth 15 -Compress)
    }
    Invoke-RestMethod @p
}

New-Item -ItemType Directory -Path $resolvedOutput -Force | Out-Null

# 1. Read Employee Identity CSV
Write-Host "Reading EMPLOYEE_IDENTITY.csv from $resolvedDataset ..." -ForegroundColor Cyan
$empCsv = Import-Csv (Join-Path $resolvedDataset "EMPLOYEE_IDENTITY.csv")

# For hackathon demo speed, provision Owner A (GID0004), Owner B (GID0001), and the first 30 active employees in Entra ID
$targetEmps = @("GID0004", "GID0001") + ($empCsv | Where-Object { $_.'Active Status' -eq 'Active' -and $_.GID -notin @("GID0004", "GID0001") } | Select-Object -First 28 | ForEach-Object { $_.GID })

Write-Host "Provisioning $($targetEmps.Count) Entra ID Users..." -ForegroundColor Cyan
$identityMapSql = @()

foreach ($gid in $targetEmps) {
    $e = $empCsv | Where-Object { $_.GID -eq $gid }
    $disp = "$($e.'First Name') $($e.'Last Name')"
    $upn = "$prefix-$($e.GID)@$VerifiedDomain"
    $mailNick = "$prefix-$($e.GID)"
    $pwd = "Aa1!" + [guid]::NewGuid().ToString('N').Substring(0, 16)
    
    try {
        # Check if user already exists
        $existing = az ad user list --upn $upn -o json | ConvertFrom-Json
        if ($existing -and $existing.id) {
            $userObj = $existing
            Write-Host "User already exists: $upn ($($userObj.id))" -ForegroundColor Gray
        } else {
            $userBody = @{
                accountEnabled    = $true
                displayName       = $disp
                mailNickname      = $mailNick
                userPrincipalName = $upn
                passwordProfile   = @{
                    forceChangePasswordNextSignIn = $false
                    password                      = $pwd
                }
            }
            $userObj = Graph 'POST' 'users' $userBody
            Write-Host "Created user: $upn ($($userObj.id))" -ForegroundColor Green
        }
        $identityMapSql += "INSERT INTO src.IdentityMap (ObjectId, EmployeeId) VALUES ('$($userObj.id)', '$gid');"
    } catch {
        Write-Warning "Failed to create user $upn: $_"
    }
}

# 2. Provision Security Groups matching Entitlements
Write-Host "Reading ENTITLEMENT_CATALOG.csv from $resolvedDataset ..." -ForegroundColor Cyan
$entCsv = Import-Csv (Join-Path $resolvedDataset "ENTITLEMENT_CATALOG.csv")
$groupMapSql = @()

$sampleEnts = $entCsv | Select-Object -First 16
Write-Host "Provisioning $($sampleEnts.Count) Entra Security Groups..." -ForegroundColor Cyan

foreach ($ent in $sampleEnts) {
    $entId = $ent.Entitlement_ID
    $groupName = "$prefix-$entId"
    try {
        $existingGrp = az ad group list --display-name $groupName -o json | ConvertFrom-Json
        if ($existingGrp -and $existingGrp.id) {
            $grpObj = $existingGrp
            Write-Host "Group already exists: $groupName ($($grpObj.id))" -ForegroundColor Gray
        } else {
            $grpBody = @{
                displayName     = $groupName
                mailEnabled     = $false
                mailNickname    = $groupName
                securityEnabled = $true
                description     = "Synthetic Entra Security Group for $entId ($($ent.Entitlement_Name))"
            }
            $grpObj = Graph 'POST' 'groups' $grpBody
            Write-Host "Created group: $groupName ($($grpObj.id))" -ForegroundColor Green
        }
        $groupMapSql += "INSERT INTO src.GroupMap (EntitlementId, ObjectId) VALUES ('$entId', '$($grpObj.id)');"
    } catch {
        Write-Warning "Failed to create group $groupName: $_"
    }
}

# 3. Output identity-map.sql
$outSqlPath = Join-Path $resolvedOutput "identity-map.sql"
$allSql = @(
    "-- Auto-generated Identity and Group Mappings for Team20",
    "DELETE FROM src.IdentityMap;",
    "DELETE FROM src.GroupMap;",
    ""
) + $identityMapSql + @("") + $groupMapSql

$allSql | Set-Content -Path $outSqlPath -Encoding UTF8
Write-Host "Saved identity and group mappings to: $outSqlPath" -ForegroundColor Green
