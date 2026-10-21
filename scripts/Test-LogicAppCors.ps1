$names = Get-Content .\names.json | ConvertFrom-Json
$url = $names.ApiAUrl
Write-Host "Testing Logic App URL: $url"

try {
    $res = Invoke-WebRequest -Uri $url -Method OPTIONS -Headers @{
        'Origin' = 'https://black-ground-0e982b710.2.azurestaticapps.net'
        'Access-Control-Request-Method' = 'POST'
        'Access-Control-Request-Headers' = 'authorization,content-type'
    }
    Write-Host "OPTIONS Status: $($res.StatusCode)"
    $res.Headers
} catch {
    Write-Host "OPTIONS Error: $_"
    if ($_.Exception.Response) {
        Write-Host "Status: $($_.Exception.Response.StatusCode.value__)"
    }
}
