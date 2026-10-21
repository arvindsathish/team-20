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
$swaName = $names.StaticWeb
$rg = $names.ResourceGroup
$webDir = Join-Path (Split-Path -Parent $scriptDir) "web"

Write-Host "Getting deployment token for $swaName in $rg..." -ForegroundColor Cyan
$token = az staticwebapp secrets list --name $swaName --resource-group $rg --query "properties.apiKey" -o tsv

if (-not $token) {
    throw "Failed to retrieve deployment token for $swaName"
}

Write-Host "Deploying web/dist to $swaName from $webDir..." -ForegroundColor Cyan
Push-Location $webDir
try {
    if (Test-Path ".\node_modules\.bin\swa.cmd") {
        .\node_modules\.bin\swa.cmd deploy ./dist --deployment-token $token --env production
    } else {
        npx.cmd -y @azure/static-web-apps-cli deploy ./dist --deployment-token $token --env production
    }
}
finally {
    Pop-Location
}

$hostName = az staticwebapp show -n $swaName -g $rg --query defaultHostname -o tsv
Write-Host "`nSuccessfully deployed to https://$hostName" -ForegroundColor Green
