# ==============================
# Tomer Glik - Live Response Script for Windows Endpoints
# ==============================

$now = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$collectionDir = "C:\Forensics\$now"
New-Item -Path $collectionDir -ItemType Directory -Force | Out-Null

function Write-Step {
    param ([string]$text)
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host "[$timestamp] $text" -ForegroundColor Yellow
}

function Show-Progress {
    param (
        [int]$index,
        [int]$total,
        [string]$name,
        [datetime]$started
    )
    $percent = [math]::Round(($index / $total) * 100)
    $barLength = 30
    $done = [math]::Floor($percent * $barLength / 100)
    $progressBar = ('=' * $done).PadRight($barLength, '-')
    $elapsed = (Get-Date) - $started
    $eta = if ($index -gt 0) {
        [TimeSpan]::FromSeconds(($elapsed.TotalSeconds / $index) * ($total - $index))
    } else {
        [TimeSpan]::Zero
    }
    $line = "`r[$($elapsed.ToString("hh\:mm\:ss"))] Processing $name".PadRight(40) + "[$progressBar] $percent% ETA: $($eta.ToString("mm\:ss"))"
    Write-Host $line -NoNewline -ForegroundColor Cyan
}

Write-Host "`n[+] Starting data collection - $now" -ForegroundColor Green

# Basic account info
Write-Step "Gathering user and group info..."
net user > "$collectionDir\users.txt"
net localgroup > "$collectionDir\localgroups.txt"
net accounts > "$collectionDir\net_accounts.txt"

# Event logs
Write-Step "Exporting last 50 security/system/application logs..."
Get-WinEvent -LogName Security -MaxEvents 50 | Out-File "$collectionDir\SecurityLog.txt"
Get-WinEvent -LogName System -MaxEvents 50 | Out-File "$collectionDir\SystemLog.txt"
Get-WinEvent -LogName Application -MaxEvents 50 | Out-File "$collectionDir\ApplicationLog.txt"

# Drivers
Write-Step "Collecting driver list..."
driverquery /V > "$collectionDir\Drivers.txt"

# Hashing files
Write-Step "Hashing files from Downloads, Desktop and Temp folders..."
$dirsToHash = @("$env:USERPROFILE\Downloads", "$env:USERPROFILE\Desktop", "$env:TEMP")
$files = @()
foreach ($dir in $dirsToHash) {
    if (Test-Path $dir) {
        $files += Get-ChildItem -Recurse -File -Path $dir -ErrorAction SilentlyContinue
    }
}

$totalFiles = $files.Count
$startTimer = Get-Date
$count = 0

foreach ($file in $files) {
    $count++
    Show-Progress -index $count -total $totalFiles -name $file.Name -started $startTimer
    try {
        $hash = Get-FileHash -Path $file.FullName -Algorithm SHA256
        "$($hash.Hash) $($file.FullName)" | Out-File "$collectionDir\hashes.txt" -Append
    } catch {
        Write-Warning "Couldn't hash: $($file.FullName)"
    }
}
Write-Host ""

# Zipping everything
Compress-Archive -Path $collectionDir -DestinationPath "$collectionDir.zip"
Write-Host "`n[+] Done! Output archived to: $collectionDir.zip" -ForegroundColor Green
