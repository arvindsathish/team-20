<#
.SYNOPSIS
    Track A: registers the Team20 Entra apps (API resource server + SPA client).
.DESCRIPTION
    Idempotent. Creates Team20_RolePatrol-API-<suffix> exposing delegated scope
    RolePatrol.Access (token v2) and Team20_RolePatrol-Browser-<suffix> as an SPA
    client authorized for that scope, grants tenant admin consent, and writes
    ApiClientId / SpaClientId back into names.json.
#>
[CmdletBinding()]
param([string]$NamesFile = "..\names.json")

$ErrorActionPreference = 'Stop'
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$namesPath = Join-Path $scriptDir $NamesFile
$names = Get-Content $namesPath -Raw | ConvertFrom-Json
$tmp = Join-Path ([IO.Path]::GetTempPath()) "t20-graph-body.json"

function Invoke-Graph([string]$Method, [string]$Uri, $Body) {
    $args = @('rest', '--method', $Method, '--uri', "https://graph.microsoft.com/v1.0/$Uri")
    if ($null -ne $Body) {
        [IO.File]::WriteAllText($tmp, ($Body | ConvertTo-Json -Depth 20 -Compress), [Text.UTF8Encoding]::new($false))
        $args += @('--headers', 'Content-Type=application/json', '--body', "@$tmp")
    }
    $out = & az @args
    if ($LASTEXITCODE -ne 0) { throw "Graph $Method $Uri failed" }
    if ($out) { $out | ConvertFrom-Json }
}

function Get-OrCreateApp([string]$DisplayName) {
    $found = az ad app list --display-name $DisplayName -o json | ConvertFrom-Json
    if ($found -and $found.Count -gt 0) { return $found[0] }
    Write-Host "Creating app registration $DisplayName ..." -ForegroundColor Cyan
    az ad app create --display-name $DisplayName --sign-in-audience AzureADMyOrg -o json | ConvertFrom-Json
}

function Ensure-ServicePrincipal([string]$AppId) {
    $sp = az ad sp list --filter "appId eq '$AppId'" -o json | ConvertFrom-Json
    if ($sp -and $sp.Count -gt 0) { return $sp[0] }
    az ad sp create --id $AppId -o json | ConvertFrom-Json
}

# ---- 1. API app (resource server) ----
$api = Get-OrCreateApp $names.ApiAppName
$existingScope = $api.api.oauth2PermissionScopes | Where-Object { $_.value -eq 'RolePatrol.Access' } | Select-Object -First 1
$scopeId = if ($existingScope) { $existingScope.id } else { [guid]::NewGuid().ToString() }

$scopeDef = @{
    id = $scopeId
    adminConsentDescription = 'Allows the Role Patrol portal to call the Role Patrol API on behalf of the signed-in role owner.'
    adminConsentDisplayName = 'Access Role Patrol'
    userConsentDescription  = 'Allow the portal to call the Role Patrol API as you.'
    userConsentDisplayName  = 'Access Role Patrol'
    isEnabled = $true
    type = 'User'
    value = 'RolePatrol.Access'
}
Invoke-Graph PATCH "applications/$($api.id)" @{
    identifierUris = @("api://$($api.appId)")
    api = @{ requestedAccessTokenVersion = 2; oauth2PermissionScopes = @($scopeDef) }
} | Out-Null
Write-Host "API app $($names.ApiAppName): $($api.appId) (scope RolePatrol.Access $scopeId)" -ForegroundColor Green

# ---- 2. SPA app (public client) ----
$spa = Get-OrCreateApp $names.SpaAppName

if (-not $names.SwaUrl -and $names.ResourceGroup -and $names.StaticWeb) {
    try {
        $swaExists = az staticwebapp list -g $names.ResourceGroup --query "[?name=='$($names.StaticWeb)'].name" -o tsv 2>$null
        if ($swaExists -and $swaExists.Trim() -eq $names.StaticWeb) {
            $swaHost = az staticwebapp show -g $names.ResourceGroup -n $names.StaticWeb --query "defaultHostname" -o tsv 2>$null
            if ($swaHost) {
                $names | Add-Member -NotePropertyName SwaUrl -NotePropertyValue "https://$swaHost" -Force
            }
        }
    } catch {}
}

$spaPayload = @{
    requiredResourceAccess = @(@{
        resourceAppId = $api.appId
        resourceAccess = @(@{ id = $scopeId; type = 'Scope' })
    })
}

if ($names.SwaUrl) {
    $spaPayload['spa'] = @{ redirectUris = @("$($names.SwaUrl)/bridge.html", "$($names.SwaUrl)/") }
} else {
    $spaPayload['spa'] = @{ redirectUris = @("http://localhost:3000/bridge.html", "http://localhost:3000/") }
}

Invoke-Graph PATCH "applications/$($spa.id)" $spaPayload | Out-Null
Write-Host "SPA app $($names.SpaAppName): $($spa.appId)" -ForegroundColor Green

# Pre-authorize the SPA on the API (no per-user consent prompt)
Invoke-Graph PATCH "applications/$($api.id)" @{
    api = @{
        requestedAccessTokenVersion = 2
        oauth2PermissionScopes = @($scopeDef)
        preAuthorizedApplications = @(@{ appId = $spa.appId; delegatedPermissionIds = @($scopeId) })
    }
} | Out-Null

# ---- 3. Service principals + admin consent ----
$apiSp = Ensure-ServicePrincipal $api.appId
$spaSp = Ensure-ServicePrincipal $spa.appId
$grants = (Invoke-Graph GET "oauth2PermissionGrants?`$filter=clientId eq '$($spaSp.id)' and resourceId eq '$($apiSp.id)'").value
if (-not $grants -or $grants.Count -eq 0) {
    Invoke-Graph POST 'oauth2PermissionGrants' @{
        clientId = $spaSp.id; consentType = 'AllPrincipals'; resourceId = $apiSp.id; scope = 'RolePatrol.Access'
    } | Out-Null
    Write-Host "Admin consent granted for RolePatrol.Access." -ForegroundColor Green
} else {
    Write-Host "Admin consent already present." -ForegroundColor Green
}

# ---- 4. Persist IDs into names.json ----
$names | Add-Member -NotePropertyName ApiClientId -NotePropertyValue $api.appId -Force
$names | Add-Member -NotePropertyName SpaClientId -NotePropertyValue $spa.appId -Force
[IO.File]::WriteAllText($namesPath, ($names | ConvertTo-Json -Depth 5), [Text.UTF8Encoding]::new($false))
Write-Host "names.json updated with ApiClientId / SpaClientId." -ForegroundColor Green
