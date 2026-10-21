Write-Host "=== 1. Checking Entra ID Users & Groups ===" -ForegroundColor Cyan
$users = az ad user list --filter "startswith(userPrincipalName, 'team20-204508')" | ConvertFrom-Json
Write-Host "Entra Users matching 'team20-204508': $($users.Count)"
$groups = az ad group list --filter "startswith(displayName, 'team20-204508')" | ConvertFrom-Json
Write-Host "Entra Groups matching 'team20-204508': $($groups.Count)"

Write-Host "`n=== 2. Checking Logic App Workflows ===" -ForegroundColor Cyan
$rg = "rg-Team20-204508"
$wfA = az logic workflow show -g $rg -n "Team20_la_api_a_204508" | ConvertFrom-Json
$actionsA = $wfA.definition.actions | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
Write-Host "Team20_la_api_a_204508 actions: $($actionsA -join ', ')"

$wfB = az logic workflow show -g $rg -n "Team20_la_api_b_204508" | ConvertFrom-Json
$actionsB = $wfB.definition.actions | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
Write-Host "Team20_la_api_b_204508 actions: $($actionsB -join ', ')"

Write-Host "`n=== 3. Checking Static Web App Live Bundle Config ===" -ForegroundColor Cyan
$liveConfig = Invoke-RestMethod -Uri "https://black-ground-0e982b710.2.azurestaticapps.net" -UseBasicParsing
if ($liveConfig -match 'RP_CONFIG\s*=\s*(\{.+?\});') {
    Write-Host "Live window.RP_CONFIG found in HTML:" -ForegroundColor Green
    $matches[1]
} else {
    Write-Host "Could not regex RP_CONFIG from live HTML"
}
