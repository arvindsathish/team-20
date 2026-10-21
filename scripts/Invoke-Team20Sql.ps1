[CmdletBinding()]
param(
    [string]$Query,
    [string]$InputFile
)
$names = Get-Content (Join-Path $PSScriptRoot '..\names.json') -Raw | ConvertFrom-Json
$token = az account get-access-token --resource "https://database.windows.net/" --query accessToken -o tsv
$p = @{ ServerInstance = "$($names.SqlServer).database.windows.net"; Database = $names.Database; AccessToken = $token; TrustServerCertificate = $true; QueryTimeout = 300; ErrorAction = 'Stop' }
if ($InputFile) { $p.InputFile = $InputFile } else { $p.Query = $Query }
Invoke-Sqlcmd @p | Format-Table -AutoSize -Wrap | Out-String -Width 250
