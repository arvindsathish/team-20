<#
.SYNOPSIS
    Provisions Microsoft Entra ID users and security groups matching the Hackathon datasets.
.DESCRIPTION
    Reads EMPLOYEE_IDENTITY.csv and ENTITLEMENT_CATALOG.csv to create corresponding
    Entra ID users and security groups, and outputs identity-map.sql for Azure SQL.
.PARAMETER VerifiedDomain
    Your verified Microsoft Entra ID domain (e.g. yourtenant.onmicrosoft.com).
.PARAMETER Prefix
    Resource prefix from names.json (e.g. team20-204508).
.PARAMETER OutputDirectory
    Directory to save identity-map.sql and mapping CSVs.
.PARAMETER DatasetDir
    Directory containing EMPLOYEE_IDENTITY.csv and ENTITLEMENT_CATALOG.csv.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)][string]$VerifiedDomain,
    [Parameter(Mandatory=$true)][string]$Prefix,
    [Parameter(Mandatory=$false)][string]$OutputDirectory = ".\directory-output",
    [Parameter(Mandatory=$false)][string]$DatasetDir = ".\datasets"
)

$ErrorActionPreference = "Stop"

$account = az account show -o json | ConvertFrom-Json
if (-not $account.id) { throw "No active Azure CLI session found. Run 'az login'." }

$token = az account get-access-token --resource-type ms-graph --query accessToken -o tsv
if (-not $token) { throw "Failed to acquire Microsoft Graph token." }
$headers = @{ Authorization = "Bearer $token" }

function Graph([string]$Method, [string]$Path, $Body) {
    $p = @{ Method = $Method; Uri = "https://graph.microsoft.com/v1.0/$Path"; Headers = $headers; ErrorAction = 'Stop' }
    if ($null -ne $Body) {
        $p.ContentType = 'application/json'
        $p.Body = ($Body | ConvertTo-Json -Depth 15 -Compress)
    }
    Invoke-RestMethod @p
}

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null

# 1. Read Employee Identity CSV
Write-Host "Reading EMPLOYEE_IDENTITY.csv ..." -ForegroundColor Cyan
$empCsv = Import-Csv (Join-Path $DatasetDir "EMPLOYEE_IDENTITY.csv")
$users = @()

# For hackathon demo speed, provision Owner A (GID0004), Owner B (GID0001), and the first 30 active employees in Entra ID
$targetEmps = @("GID0004", "GID0001") + ($empCsv | Where-Object { $_.'Active Status' -eq 'Active' -and $_.GID -notin @("GID0004", "GID0001") } | Select-Object -First 28 | ForEach-Object { $_.GID })

Write-Host "Provisioning $($targetEmps.Count) Entra ID Users..." -ForegroundColor Cyan
foreach ($gid in $targetEmps) {
    $e = $empCsv | Where-Object { $_.GID -eq $gid }
    $disp = "$($e.'First Name') $($e.'Last Name')"
    $upn = "$Prefix-$($e.GID)@$VerifiedDomain"
    $mailNick = "$Prefix-$($e.GID)"
    $pwd = "Aa1!" + [guid]::NewGuid().ToString('N').Substring(0, 16)
    
    try {
        $u = Graph POST 'users' @{
            accountEnabled = $true
            displayName    = "$Prefix $disp ($gid)"
            mailNickname   = $mailNick
            userPrincipalName = $upn
            passwordProfile = @{ password = $pwd; forceChangePasswordNextSignIn = $false }
        }
        $users += [pscustomobject]@{ EmployeeId = $gid; ObjectId = $u.id; UPN = $upn }
        Write-Host "Created Entra user: $upn ($($u.id))" -ForegroundColor Green
    } catch {
        # If user exists, look up ID
        $existing = Graph GET "users/$upn" $null
        $users += [pscustomobject]@{ EmployeeId = $gid; ObjectId = $existing.id; UPN = $upn }
        Write-Host "Reused existing Entra user: $upn" -ForegroundColor Yellow
    }
}
$users | Export-Csv -LiteralPath (Join-Path $OutputDirectory 'identity-map.csv') -NoTypeInformation -Encoding UTF8

# 2. Read Entitlement Catalog CSV and provision Entra Security Groups
Write-Host "Reading ENTITLEMENT_CATALOG.csv ..." -ForegroundColor Cyan
$entCsv = Import-Csv (Join-Path $DatasetDir "ENTITLEMENT_CATALOG.csv")
# Provision security groups for the first 16 core entitlements
$targetEnts = $entCsv | Select-Object -First 16
$groups = @()

Write-Host "Provisioning $($targetEnts.Count) Entra Security Groups..." -ForegroundColor Cyan
foreach ($ent in $targetEnts) {
    $entId = $ent.Entitlement_ID
    $grpName = "$Prefix-$entId"
    try {
        $g = Graph POST 'groups' @{
            displayName     = $grpName
            mailEnabled     = $false
            mailNickname    = $grpName
            securityEnabled = $true
            description     = "Role Patrol Hackathon Group for $($ent.Entitlement_Name) ($entId)"
        }
        $groups += [pscustomobject]@{ EntitlementId = $entId; ObjectId = $g.id }
        Write-Host "Created Entra group: $grpName ($($g.id))" -ForegroundColor Green
    } catch {
        $existing = (Graph GET "groups?`$filter=displayName eq '$grpName'" $null).value[0]
        $groups += [pscustomobject]@{ EntitlementId = $entId; ObjectId = $existing.id }
        Write-Host "Reused existing Entra group: $grpName" -ForegroundColor Yellow
    }
}
$groups | Export-Csv -LiteralPath (Join-Path $OutputDirectory 'group-map.csv') -NoTypeInformation -Encoding UTF8

# 2b. Add users to Entra Security Groups based on dataset assignments
Write-Host "Assigning provisioned users to Entra security groups..." -ForegroundColor Cyan
$assignCsvPath = Join-Path $DatasetDir "ROLE_ASSIGNMENT.csv"
$mapCsvPath = Join-Path $DatasetDir "ROLE_ENTITLEMENT_MAP.csv"

if ((Test-Path $assignCsvPath) -and (Test-Path $mapCsvPath)) {
    $assignCsv = Import-Csv $assignCsvPath
    $mapCsv = Import-Csv $mapCsvPath
    $userMap = @{}
    foreach ($u in $users) { $userMap[$u.EmployeeId] = $u.ObjectId }
    $groupMap = @{}
    foreach ($g in $groups) { $groupMap[$g.EntitlementId] = $g.ObjectId }

    $activeMemberships = @{}
    foreach ($a in $assignCsv) {
        if ($userMap.ContainsKey($a.GID)) {
            $matchingEnts = $mapCsv | Where-Object { $_.Business_Role_ID -eq $a.Business_Role_ID }
            foreach ($m in $matchingEnts) {
                if ($groupMap.ContainsKey($m.Entitlement_ID)) {
                    $key = "$($a.GID)|$($m.Entitlement_ID)"
                    $activeMemberships[$key] = @{
                        UserId = $userMap[$a.GID]
                        GroupId = $groupMap[$m.Entitlement_ID]
                        EntitlementId = $m.Entitlement_ID
                        EmployeeId = $a.GID
                    }
                }
            }
        }
    }

    $assignedCount = 0
    foreach ($item in $activeMemberships.Values) {
        try {
            Graph POST "groups/$($item.GroupId)/members/`$ref" @{
                "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$($item.UserId)"
            } | Out-Null
            $assignedCount++
        } catch {
            # Member already present or throttled
        }
    }
    Write-Host "Assigned $assignedCount user memberships into Entra security groups." -ForegroundColor Green
}

# 3. Generate identity-map.sql for Azure SQL
$sqlLines = @("SET XACT_ABORT ON;", "BEGIN TRAN;")
foreach ($u in $users) {
    $sqlLines += "IF NOT EXISTS (SELECT 1 FROM src.IdentityMap WHERE EmployeeId = '$($u.EmployeeId)') INSERT INTO src.IdentityMap VALUES ('$($u.EmployeeId)', '$($u.ObjectId)');"
}
foreach ($g in $groups) {
    $sqlLines += "IF NOT EXISTS (SELECT 1 FROM src.GroupMap WHERE EntitlementId = '$($g.EntitlementId)') INSERT INTO src.GroupMap VALUES ('$($g.EntitlementId)', '$($g.ObjectId)');"
}
$sqlLines += "COMMIT;"
[IO.File]::WriteAllLines((Join-Path $OutputDirectory 'identity-map.sql'), $sqlLines, [Text.UTF8Encoding]::new($false))

Write-Host "identity-map.sql successfully generated in $OutputDirectory!" -ForegroundColor Green
[pscustomobject]@{
    ProvisionedUsers  = $users.Count
    ProvisionedGroups = $groups.Count
    OutputDirectory   = $OutputDirectory
    OwnerA_GID        = "GID0004"
    OwnerA_ObjectId   = ($users | Where-Object { $_.EmployeeId -eq 'GID0004' }).ObjectId
    OwnerB_GID        = "GID0001"
    OwnerB_ObjectId   = ($users | Where-Object { $_.EmployeeId -eq 'GID0001' }).ObjectId
}
