# ===== SETTINGS =====
$DaysBack = 365
$StartTime = (Get-Date).AddDays(-$DaysBack)
$OutputFile = "$env:USERPROFILE\Desktop\Security_Audit_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"

Write-Host "Collecting logs since $StartTime..."
Write-Host "Output file: $OutputFile"
Write-Host "-------------------------------------"

$Results = @()

# 1️⃣ Login Failures (Event ID 4625)
$LoginFailures = Get-WinEvent -FilterHashtable @{
    LogName = 'Security'
    ID = 4625
    StartTime = $StartTime
} -ErrorAction SilentlyContinue

foreach ($event in $LoginFailures) {
    $Results += [PSCustomObject]@{
        Category     = "Login Failure"
        TimeCreated  = $event.TimeCreated
        EventID      = $event.Id
        Source       = $event.ProviderName
        Message      = $event.Message -replace "`r`n"," "
    }
}

# 2️⃣ Device Insertions (Kernel-PnP)
$DeviceEvents = Get-WinEvent -FilterHashtable @{
    LogName = 'System'
    ProviderName = 'Microsoft-Windows-Kernel-PnP'
    StartTime = $StartTime
} -ErrorAction SilentlyContinue | 
Where-Object { $_.Id -in 20001,20003,2100 }

foreach ($event in $DeviceEvents) {
    $Results += [PSCustomObject]@{
        Category     = "Device Insertion"
        TimeCreated  = $event.TimeCreated
        EventID      = $event.Id
        Source       = $event.ProviderName
        Message      = $event.Message -replace "`r`n"," "
    }
}

# 3️⃣ Driver Installations
$DriverEvents = Get-WinEvent -FilterHashtable @{
    LogName = 'System'
    ProviderName = 'Microsoft-Windows-DriverFrameworks-UserMode'
    StartTime = $StartTime
} -ErrorAction SilentlyContinue

foreach ($event in $DriverEvents) {
    $Results += [PSCustomObject]@{
        Category     = "Driver Installation"
        TimeCreated  = $event.TimeCreated
        EventID      = $event.Id
        Source       = $event.ProviderName
        Message      = $event.Message -replace "`r`n"," "
    }
}

# 4️⃣ Software Installations (MsiInstaller)
$SoftwareEvents = Get-WinEvent -FilterHashtable @{
    LogName = 'Application'
    ProviderName = 'MsiInstaller'
    StartTime = $StartTime
} -ErrorAction SilentlyContinue |
Where-Object { $_.Id -in 1033,11707 }

foreach ($event in $SoftwareEvents) {
    $Results += [PSCustomObject]@{
        Category     = "Software Installation"
        TimeCreated  = $event.TimeCreated
        EventID      = $event.Id
        Source       = $event.ProviderName
        Message      = $event.Message -replace "`r`n"," "
    }
}

# ===== Export to CSV =====
if ($Results.Count -gt 0) {
    $Results | Sort-Object TimeCreated | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8
    Write-Host "`nExport complete. File saved to:"
    Write-Host $OutputFile -ForegroundColor Green
}
else {
    Write-Host "`nNo matching events found." -ForegroundColor Yellow
}