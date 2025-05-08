# LiveResponse.ps1
$OutputDir = "C:\Forensics\$(Get-Date -Format yyyy-MM-dd_HH-mm-ss)"
New-Item -ItemType Directory -Force -Path $OutputDir

# System Info
systeminfo > "$OutputDir\systeminfo.txt"
hostname > "$OutputDir\hostname.txt"
whoami /all > "$OutputDir\whoami.txt"
Get-Date > "$OutputDir\current_time.txt"

# Running Processes
tasklist /V > "$OutputDir\tasklist.txt"
Get-Process | Sort-Object CPU -Descending | Out-File "$OutputDir\Get-Process.txt"

# Network Connections
netstat -ano > "$OutputDir\netstat.txt"
Get-NetTCPConnection | Out-File "$OutputDir\TCPConnections.txt"

# Services
Get-Service | Where-Object {$_.Status -eq 'Running'} | Out-File "$OutputDir\Services.txt"

# Scheduled Tasks
schtasks /query /fo LIST /v > "$OutputDir\ScheduledTasks.txt"

# Installed Software
Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* |
Select-Object DisplayName, DisplayVersion, Publisher, InstallDate |
Out-File "$OutputDir\InstalledPrograms.txt"

# Startup Entries
Get-CimInstance Win32_StartupCommand | Select-Object Name, Command, Location |
Out-File "$OutputDir\StartupItems.txt"

# Users and Groups
net user > "$OutputDir\users.txt"
net localgroup > "$OutputDir\localgroups.txt"
net accounts > "$OutputDir\net_accounts.txt"

# Event Logs (last 1000 events)
Get-WinEvent -LogName Security -MaxEvents 1000 | Out-File "$OutputDir\SecurityLog.txt"
Get-WinEvent -LogName System -MaxEvents 1000 | Out-File "$OutputDir\SystemLog.txt"
Get-WinEvent -LogName Application -MaxEvents 1000 | Out-File "$OutputDir\ApplicationLog.txt"

# Running Drivers
driverquery /V > "$OutputDir\Drivers.txt"

# Save Hashes of Files in Downloads/Desktop/Temp
$paths = @("$env:USERPROFILE\Downloads", "$env:USERPROFILE\Desktop", "$env:TEMP")
foreach ($path in $paths) {
    if (Test-Path $path) {
        Get-ChildItem -Recurse -File -Path $path -ErrorAction SilentlyContinue |
        ForEach-Object {
            $hash = Get-FileHash $_.FullName -Algorithm SHA256
            "$($hash.Hash) $($_.FullName)" | Out-File "$OutputDir\file_hashes.txt" -Append
        }
    }
}

# Zip the folder
Compress-Archive -Path $OutputDir -DestinationPath "$OutputDir.zip"
Write-Output "Live response collection completed. Output saved to: $OutputDir.zip"
