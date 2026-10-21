$datasetDir = Join-Path (Split-Path -Parent $PSScriptRoot) "datasets"
if (-not (Test-Path $datasetDir)) { $datasetDir = ".\datasets" }
$files = Get-ChildItem (Join-Path $datasetDir "*.csv")
foreach ($f in $files) {
    $c = Import-Csv $f.FullName
    Write-Host "`n=== $($f.Name) ($($c.Count) rows) ===" -ForegroundColor Cyan
    if ($c.Count -gt 0) {
        foreach ($prop in $c[0].PSObject.Properties.Name) {
            $maxLen = ($c | ForEach-Object { if ($_.$prop) { ($_.$prop).Length } else { 0 } } | Measure-Object -Maximum).Maximum
            Write-Host "  $prop : max $maxLen"
        }
    }
}
