$ErrorActionPreference = 'Stop'

$names = Get-Content .\names.json | ConvertFrom-Json
$swaName = $names.StaticWeb
$rg = $names.ResourceGroup

Write-Host "Getting deployment token for $swaName in $rg..." -ForegroundColor Cyan
$token = az staticwebapp secrets list --name $swaName --resource-group $rg --query "properties.apiKey" -o tsv

if (-not $token) {
    throw "Failed to retrieve deployment token for $swaName"
}

Write-Host "Deploying web/dist to $swaName..." -ForegroundColor Cyan
Push-Location .\web
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
