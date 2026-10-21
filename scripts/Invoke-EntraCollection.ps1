<#
.SYNOPSIS
    Executes live Entra ID collection into Azure SQL Database for T20 Role Patrol.
.DESCRIPTION
    Reads only the allow-listed synthetic Entra groups stored in src.GroupMap.
    Stores each Graph page through core.usp_Collect, which rejects unmapped
    objects and incomplete collections.
#>
[CmdletBinding()]
param(
    [string]$SqlServer,
    [string]$Database,
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
if (-not $resolvedNames) { $resolvedNames = Join-Path $scriptDir $NamesFile }

if (Test-Path $resolvedNames) {
    $names = Get-Content $resolvedNames | ConvertFrom-Json
    if (-not $SqlServer) { $SqlServer = $names.SqlServer }
    if (-not $Database)  { $Database  = $names.Database }
}

if (-not $SqlServer) { $SqlServer = "t020-sql-36de74" }
if (-not $Database)  { $Database = "t020_rolepatrol" }

if (-not $SqlServer.Contains(".")) {
    $SqlServer = "$SqlServer.database.windows.net"
}

Write-Host "=== Executing Live Entra Collection on $SqlServer / $Database ===" -ForegroundColor Cyan

function Get-SqlToken { az account get-access-token --resource 'https://database.windows.net/' --query accessToken -o tsv }
function Invoke-RpSql([string]$Query) {
    Invoke-Sqlcmd -ServerInstance $SqlServer -Database $Database -AccessToken (Get-SqlToken) -Query $Query -ErrorAction Stop
}
function Escape-SqlLiteral([string]$Value) { $Value.Replace("'", "''") }

$collectionId = [guid]::NewGuid()
Invoke-RpSql "EXEC core.usp_Collect @Action='Start', @CollectionId='$collectionId';" | Out-Null
Write-Host "Started collection $collectionId..." -ForegroundColor Yellow

try {
    $groups = Invoke-RpSql "SELECT EntitlementId, CONVERT(varchar(36),ObjectId) AS ObjectId FROM src.GroupMap ORDER BY EntitlementId;" |
        Select-Object EntitlementId,ObjectId
        
    if (-not $groups -or $groups.Count -eq 0) {
        Write-Warning "src.GroupMap is empty. Run Import-DirectoryFromDataset.ps1 first to map Entra groups."
    }

    $graphToken = az account get-access-token --resource 'https://graph.microsoft.com/' --query accessToken -o tsv
    if (-not $graphToken) { throw 'Unable to obtain a Microsoft Graph token.' }

    foreach ($group in $groups) {
        $next = "https://graph.microsoft.com/v1.0/groups/$($group.ObjectId)/members?`$select=id"
        do {
            $page = az rest --method get --url $next --headers "Authorization=Bearer $graphToken" --output json | ConvertFrom-Json
            if ($LASTEXITCODE -ne 0 -or $null -eq $page) { throw "Graph read failed for $($group.EntitlementId)." }
            $pageJson = $page | ConvertTo-Json -Depth 20 -Compress
            $isLast = [int](-not $page.'@odata.nextLink')
            $safeJson = Escape-SqlLiteral $pageJson
            $safeEntitlement = Escape-SqlLiteral $group.EntitlementId
            Invoke-RpSql "EXEC core.usp_Collect @Action='Page', @CollectionId='$collectionId', @EntitlementId=N'$safeEntitlement', @PageJson=N'$safeJson', @LastPage=$isLast;" | Out-Null
            $next = $page.'@odata.nextLink'
        } while ($next)
    }
    Invoke-RpSql "EXEC core.usp_Collect @Action='Finish', @CollectionId='$collectionId';" | Out-Null
    Write-Host "Completed collection successfully!" -ForegroundColor Green
    Invoke-RpSql "SELECT CollectionId, Status, StartedAt, CompletedAt, (SELECT COUNT(*) FROM core.Member m WHERE m.CollectionId=c.CollectionId) AS Members FROM core.Collection c WHERE CollectionId='$collectionId';"
}
catch {
    try { Invoke-RpSql "EXEC core.usp_Collect @Action='Fail', @CollectionId='$collectionId';" | Out-Null } catch {}
    throw
}
