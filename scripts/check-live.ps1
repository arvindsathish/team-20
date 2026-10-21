$resp = Invoke-WebRequest -Uri 'https://black-ground-0e982b710.2.azurestaticapps.net/' -UseBasicParsing
$html = $resp.Content

Write-Host "Total length: $($html.Length)"
Write-Host "Contains R_FIN: $($html.Contains('R_FIN'))"
Write-Host "Contains Finance UK: $($html.Contains('Finance UK'))"
Write-Host "Contains BR0008: $($html.Contains('BR0008'))"
Write-Host "Contains Credit Review: $($html.Contains('Credit Review'))"
Write-Host "Contains Avenra: $($html.Contains('Avenra'))"
Write-Host "Contains Salesforce: $($html.Contains('Salesforce'))"
Write-Host "Contains Jane: $($html.Contains('Jane'))"
Write-Host "Contains ENT_REPORT: $($html.Contains('ENT_REPORT'))"
Write-Host "Contains ENT0001: $($html.Contains('ENT0001'))"
