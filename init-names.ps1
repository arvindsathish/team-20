$ErrorActionPreference = 'Stop'

Write-Host "=== Step 0.1: Checking Account Context ===" -ForegroundColor Cyan
$sub = az account show --output json | ConvertFrom-Json
Write-Host "Subscription: $($sub.name) ($($sub.id))" -ForegroundColor Green
Write-Host "Tenant:       $($sub.tenantId)" -ForegroundColor Green

Write-Host "`n=== Step 0.2: Generating names.json ===" -ForegroundColor Cyan
$LOCATION = "centralus"
$randHex  = [guid]::NewGuid().ToString("N").Substring(0, 4)
$SUFFIX   = "20$randHex"
$PREFIX   = "Team20_$SUFFIX"
$RG       = "rg-Team20-$SUFFIX"

$Names = [pscustomobject]@{
    Prefix         = $PREFIX
    Suffix         = $SUFFIX
    ResourceGroup  = $RG
    Location       = $LOCATION
    SubscriptionId = $sub.id
    TenantId       = $sub.tenantId
    SqlServer      = "team20-sql-$SUFFIX"
    Database       = "team20_rolepatrol"
    Factory        = "team20-adf-$SUFFIX"
    StaticWeb      = "team20-swa-$SUFFIX"
    SearchService  = "team20-srch-$SUFFIX"
    ApiA           = "Team20_la_api_a_$SUFFIX"
    ApiB           = "Team20_la_api_b_$SUFFIX"
    Collector      = "Team20_la_collect_$SUFFIX"
    Shell          = "Team20_la_shell_$SUFFIX"
    ApiAppName     = "Team20_RolePatrol-API-$SUFFIX"
    SpaAppName     = "Team20_RolePatrol-Browser-$SUFFIX"
}

$Names | ConvertTo-Json -Depth 5 | Set-Content -Path ".\names.json" -Encoding UTF8
Write-Host "Generated names.json with Suffix: $SUFFIX" -ForegroundColor Green
Get-Content .\names.json
