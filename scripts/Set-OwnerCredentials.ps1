<#
.SYNOPSIS
    Resets the two Role Owner demo accounts (GID0004, GID0001) to fresh random passwords
    and stores them in directory-output\owner-credentials.txt (local file, not deployed).
#>
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$names = Get-Content (Join-Path $root 'names.json') -Raw | ConvertFrom-Json
$map = Import-Csv (Join-Path $root 'directory-output\identity-map.csv')
$tmp = Join-Path ([IO.Path]::GetTempPath()) 't20-pwd.json'
$lines = @("Team20 Role Patrol - Role Owner sign-in accounts (local file, do not commit)", "Portal: $($names.SwaUrl)", "")
foreach ($gid in 'GID0004', 'GID0001') {
    $u = $map | Where-Object { $_.EmployeeId -eq $gid }
    $pwd = 'Rp!' + [guid]::NewGuid().ToString('N').Substring(0, 14) + 'aZ9'
    $body = @{ passwordProfile = @{ password = $pwd; forceChangePasswordNextSignIn = $false } } | ConvertTo-Json -Compress
    [IO.File]::WriteAllText($tmp, $body, [Text.UTF8Encoding]::new($false))
    az rest --method PATCH --uri "https://graph.microsoft.com/v1.0/users/$($u.ObjectId)" --headers 'Content-Type=application/json' --body "@$tmp" | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Password reset failed for $gid" }
    $lines += "$gid  $($u.UPN)  $pwd"
}
[IO.File]::WriteAllLines((Join-Path $root 'directory-output\owner-credentials.txt'), $lines)
Write-Host "Owner credentials written to directory-output\owner-credentials.txt" -ForegroundColor Green
