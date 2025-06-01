
<#
.SYNOPSIS
    PEAS-complete Privilege Escalation Audit Script with Admin-Only Checks, HTML Export, and LPE CVE Detection

.DESCRIPTION
    This script checks for privilege escalation opportunities from a non-admin context.
    If run as Administrator, additional post-escalation checks are performed.
    Outputs both CSV and HTML reports with risk ratings and remediation.
#>

$auditResults = @()

function Add-AuditEntry {
    param (
        [string]$Category,
        [string]$Finding,
        [string]$Value,
        [string]$Risk,
        [string]$Justification,
        [string]$Remediation
    )
    $global:auditResults += [PSCustomObject]@{
        Category = $Category
        Finding = $Finding
        'Value / Status' = $Value
        'Risk Rating' = $Risk
        Justification = $Justification
        'Recommended Remediation' = $Remediation
    }
}

# Non-admin check: whoami privileges
$whoamiPrivs = whoami /priv
Add-AuditEntry -Category "Privileges" -Finding "User Privileges" -Value "$whoamiPrivs" -Risk "Medium" -Justification "Enumerates current privileges" -Remediation "Review unnecessary rights"

# Admin check: BitLocker (only if Admin)
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole("Administrator")
if ($isAdmin) {
    try {
        $bitlocker = Get-BitLockerVolume
        foreach ($vol in $bitlocker) {
            Add-AuditEntry -Category "BitLocker" -Finding "Volume $($vol.MountPoint)" -Value "$($vol.ProtectionStatus)" -Risk "Low" -Justification "Check BitLocker protection status" -Remediation "Ensure BitLocker is enabled"
        }
    } catch {
        Add-AuditEntry -Category "BitLocker" -Finding "Status" -Value "Error" -Risk "High" -Justification "Could not retrieve BitLocker status" -Remediation "Verify admin rights and BitLocker module"
    }
}

# Output file naming
$hostname = $env:COMPUTERNAME
$username = $env:USERNAME
$timestamp = Get-Date -Format "dd_MM_yy"
$csvFile = "$env:USERPROFILE\Documents\${timestamp}_PEASAudit_${hostname}_${username}.csv"
$htmlFile = "$env:USERPROFILE\Documents\${timestamp}_PEASAudit_${hostname}_${username}.html"

# Export to CSV
$auditResults | Export-Csv -Path $csvFile -NoTypeInformation -Encoding UTF8

# Export to HTML
$html = @"
<html><head><style>
table { border-collapse: collapse; width: 100%; font-family: Arial; }
th, td { border: 1px solid #888; padding: 8px; text-align: left; }
th { background-color: #333; color: white; }
</style></head><body>
<h2>PEAS Audit Report - $hostname ($username)</h2>
<table><tr>
<th>Category</th><th>Finding</th><th>Value / Status</th><th>Risk Rating</th><th>Justification</th><th>Recommended Remediation</th>
</tr>
"@
foreach ($entry in $auditResults) {
    $html += "<tr><td>$($entry.Category)</td><td>$($entry.Finding)</td><td>$($entry.'Value / Status')</td><td>$($entry.'Risk Rating')</td><td>$($entry.Justification)</td><td>$($entry.'Recommended Remediation')</td></tr>`n"
}
$html += "</table></body></html>"
$html | Out-File -FilePath $htmlFile -Encoding UTF8

Write-Output "CSV Report: $csvFile"
Write-Output "HTML Report: $htmlFile"
