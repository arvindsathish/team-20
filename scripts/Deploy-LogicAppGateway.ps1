<#
.SYNOPSIS
    Track C: deploys the production Logic App API gateways (replaces the placeholder 'Healthy' workflows).
.DESCRIPTION
    - Enables Entra (RBAC) authentication on Azure AI Search and grants each gateway's managed
      identity the 'Search Index Data Reader' role (no Search key is ever sent to the browser).
    - Creates the managed-identity Azure SQL API connection.
    - Renders templates/logicapp-api-workflow.json for the US lead (GID0004) and Canada lead (GID0001):
      OAuth 2.0 trigger policy (iss/aud/tid/oid/azp/scp), SAS disabled, calls api.usp_Gateway.
    - Prints the OAuth-protected trigger URLs and updates web/config.json.
#>
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$namesPath = Join-Path $root 'names.json'
$names = Get-Content $namesPath -Raw | ConvertFrom-Json
$rg = $names.ResourceGroup
$sub = $names.SubscriptionId
$tmp = Join-Path ([IO.Path]::GetTempPath()) 't20-arm-body.json'
$idMap = Import-Csv (Join-Path $root 'directory-output\identity-map.csv')
$ownerA = ($idMap | Where-Object EmployeeId -eq 'GID0004').ObjectId
$ownerB = ($idMap | Where-Object EmployeeId -eq 'GID0001').ObjectId
if (-not $ownerA -or -not $ownerB) { throw 'identity-map.csv is missing GID0004/GID0001' }
if (-not $names.ApiClientId -or -not $names.SpaClientId) { throw 'Run scripts/Deploy-Entra.ps1 first.' }

function Invoke-Arm([string]$Method, [string]$Uri, [string]$BodyFile) {
    $a = @('rest', '--method', $Method, '--uri', "https://management.azure.com$Uri")
    if ($BodyFile) { $a += @('--headers', 'Content-Type=application/json', '--body', "@$BodyFile") }
    $out = & az @a
    if ($LASTEXITCODE -ne 0) { throw "ARM $Method $Uri failed" }
    if ($out) { $out | ConvertFrom-Json }
}

function Render([string]$TemplatePath, [hashtable]$Tokens) {
    $t = [IO.File]::ReadAllText($TemplatePath)
    foreach ($k in $Tokens.Keys) { $t = $t.Replace($k, [string]$Tokens[$k]) }
    if ($t -match '__[A-Z_]+__') { throw "Unreplaced token in $TemplatePath : $($Matches[0])" }
    $t
}

# --- 1. AI Search: allow Entra tokens ---
Write-Host '>>> Enabling Entra authentication on Azure AI Search ...' -ForegroundColor Yellow
az search service update --name $names.SearchService --resource-group $rg --auth-options aadOrApiKey --aad-auth-failure-mode http401WithBearerChallenge -o none
$searchId = az search service show --name $names.SearchService --resource-group $rg --query id -o tsv

# --- 2. Managed-identity SQL API connection ---
$connName = "sql-$($names.Suffix)"
Write-Host ">>> Creating SQL API connection $connName ..." -ForegroundColor Yellow
$connBody = Render (Join-Path $root 'templates\sql-api-connection.json') @{
    '__SUBSCRIPTION_ID__' = $sub; '__LOCATION__' = $names.Location; '__CONNECTION_NAME__' = $connName
}
[IO.File]::WriteAllText($tmp, $connBody, [Text.UTF8Encoding]::new($false))
Invoke-Arm PUT "/subscriptions/$sub/resourceGroups/$rg/providers/Microsoft.Web/connections/${connName}?api-version=2016-06-01" $tmp | Out-Null

# --- 3. Gateways ---
$gateways = @(
    @{ Name = $names.ApiA; Owner = $ownerA; Gid = 'GID0004'; Key = 'ApiAUrl' },
    @{ Name = $names.ApiB; Owner = $ownerB; Gid = 'GID0001'; Key = 'ApiBUrl' }
)
$urls = @{}
foreach ($g in $gateways) {
    Write-Host ">>> Deploying gateway $($g.Name) for $($g.Gid) (oid $($g.Owner)) ..." -ForegroundColor Yellow
    $body = Render (Join-Path $root 'templates\logicapp-api-workflow.json') @{
        '__TENANT_ID__' = $names.TenantId; '__API_CLIENT_ID__' = $names.ApiClientId; '__SPA_CLIENT_ID__' = $names.SpaClientId
        '__OWNER_OBJECT_ID__' = $g.Owner; '__SUBSCRIPTION_ID__' = $sub; '__RESOURCE_GROUP__' = $rg
        '__SQL_CONNECTION_NAME__' = $connName; '__LOCATION__' = $names.Location; '__SEARCH_SERVICE__' = $names.SearchService
        '__SQL_SERVER__' = $names.SqlServer; '__DATABASE__' = $names.Database; '__SWA_URL__' = $names.SwaUrl
    }
    [IO.File]::WriteAllText($tmp, $body, [Text.UTF8Encoding]::new($false))
    $wf = Invoke-Arm PUT "/subscriptions/$sub/resourceGroups/$rg/providers/Microsoft.Logic/workflows/$($g.Name)?api-version=2019-05-01" $tmp
    $principalId = $wf.identity.principalId
    if (-not $principalId) { $principalId = az logic workflow show -g $rg -n $g.Name --query identity.principalId -o tsv }
    Write-Host "   managed identity: $principalId"

    az role assignment create --assignee-object-id $principalId --assignee-principal-type ServicePrincipal --role 'Search Index Data Reader' --scope $searchId -o none 2>$null
    $urls[$g.Key] = "$($wf.properties.accessEndpoint)/triggers/manual/paths/invoke?api-version=2016-06-01"
    Write-Host "   trigger: $($urls[$g.Key])" -ForegroundColor Cyan
}

# --- 4. Persist to names.json ---
$names | Add-Member -NotePropertyName ApiAUrl -NotePropertyValue $urls.ApiAUrl -Force
$names | Add-Member -NotePropertyName ApiBUrl -NotePropertyValue $urls.ApiBUrl -Force
$names | Add-Member -NotePropertyName OwnerAObjectId -NotePropertyValue $ownerA -Force
$names | Add-Member -NotePropertyName OwnerBObjectId -NotePropertyValue $ownerB -Force
[IO.File]::WriteAllText($namesPath, ($names | ConvertTo-Json -Depth 5), [Text.UTF8Encoding]::new($false))

# --- 5. web/config.json (no secrets: OAuth-only triggers, no search key) ---
$cfg = [ordered]@{
    tenantId      = $names.TenantId
    clientId      = $names.SpaClientId
    apiClientId   = $names.ApiClientId
    redirectUri   = "$($names.SwaUrl)/bridge.html"
    apiByObjectId = [ordered]@{ $ownerA = $urls.ApiAUrl; $ownerB = $urls.ApiBUrl }
}
[IO.File]::WriteAllText((Join-Path $root 'web\config.json'), ($cfg | ConvertTo-Json -Depth 5), [Text.UTF8Encoding]::new($false))
Write-Host 'web/config.json written (no search key, no SAS signature).' -ForegroundColor Green
