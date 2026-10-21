<#
.SYNOPSIS
    Applies the portal API layer to team20_rolepatrol and republishes the assessment through Data Factory.
.DESCRIPTION
    1. Runs sql/07_portal_api.sql and sql/08_portfolio_access.sql
    2. Loads src.Application from datasets/APPLICATION_MASTER.csv
    3. Re-derives src.Ticket.ContextCode from each ticket's entitlement application
       (same rule as the corrected import scripts)
    4. Triggers the ADF pipeline RolePatrolAssessment (core.usp_Ingest + core.usp_Assess) and waits
#>
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$names = Get-Content (Join-Path $root 'names.json') -Raw | ConvertFrom-Json
$sql = Join-Path $PSScriptRoot 'Invoke-Team20Sql.ps1'

& $sql -InputFile (Join-Path $root 'sql\07_portal_api.sql') | Out-Host

# Applications from the dataset
$apps = Import-Csv (Join-Path $root 'datasets\APPLICATION_MASTER.csv')
$esc = { param($s) "'" + ([string]$s).Replace("'", "''") + "'" }
$rows = foreach ($a in $apps) {
    $active = if ($a.Active_Status -eq 'Active') { 1 } else { 0 }
    "($(& $esc $a.Application_ID), $(& $esc $a.Application_Name), $(& $esc $a.Application_Category), $active)"
}
$appSql = "DELETE FROM src.Application; INSERT INTO src.Application (ApplicationId, Name, Category, Active) VALUES " + ($rows -join ",") + "; SELECT COUNT(*) AS Applications FROM src.Application;"
& $sql -Query $appSql | Out-Host

# Ticket context = entitlement application (matches corrected importer)
& $sql -Query "UPDATE t SET ContextCode = e.ContextCode FROM src.Ticket t JOIN src.Entitlement e ON e.EntitlementId = t.EntitlementId WHERE t.ContextCode <> e.ContextCode; SELECT @@ROWCOUNT AS TicketsRealigned;" | Out-Host

& $sql -InputFile (Join-Path $root 'sql\08_portfolio_access.sql') | Out-Host

# Republish the assessment via Data Factory
Write-Host "Triggering ADF pipeline RolePatrolAssessment ..." -ForegroundColor Cyan
$runId = az datafactory pipeline create-run --factory-name $names.Factory --resource-group $names.ResourceGroup --name RolePatrolAssessment --query runId -o tsv
Write-Host "ADF run: $runId"
for ($i = 0; $i -lt 40; $i++) {
    Start-Sleep -Seconds 6
    $status = az datafactory pipeline-run show --factory-name $names.Factory --resource-group $names.ResourceGroup --run-id $runId --query status -o tsv
    Write-Host "  status: $status"
    if ($status -in 'Succeeded', 'Failed', 'Cancelled') { break }
}
if ($status -ne 'Succeeded') { throw "ADF run ended with status $status" }
& $sql -Query "SELECT (SELECT COUNT(*) FROM core.Impact WHERE RunId=(SELECT RunId FROM core.Published)) Impacts, (SELECT COUNT(*) FROM core.Evidence WHERE RunId=(SELECT RunId FROM core.Published)) Evidence, (SELECT COUNT(*) FROM casework.ReviewCase) Cases, (SELECT SUM(AffectedEmployees) FROM core.Impact WHERE RunId=(SELECT RunId FROM core.Published)) AffectedEmployees;" | Out-Host
