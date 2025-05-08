# BasicForensicArt

## ⚠️ Notes

- **Run as Administrator** to ensure full access to system data.
- The script does **not** modify any system state – it only reads and saves data.
- This is **not** a RAM dumper. For memory capture, use tools like [Magnet RAM Capture](https://www.magnetforensics.com/resources/magnet-ram-capture/).
- Recommended for use in triage, threat hunting, or when IR teams need fast visibility.

## 🧠 Tip for Use

Copy this script to a USB drive or incident response toolkit folder. After running it, you’ll get a `.zip` file with all the findings ready for offline analysis.

---

# 🛡️ Windows Live Response Script

This PowerShell script helps collect essential forensic artifacts from a Windows machine during incident response or threat investigations. It’s designed for security analysts, SOC teams, and DFIR professionals who need a quick and reliable way to gather live data from a potentially compromised system.

## 🔍 What It Does

The script collects key information such as:

- System details (hostname, time, users, accounts)
- Running processes and network connections
- Scheduled tasks and startup entries
- Installed software
- Active services and drivers
- Event logs (Security, System, Application)
- File hashes from `Downloads`, `Desktop`, and `Temp` folders

All output is saved into a timestamped folder and compressed into a `.zip` archive for easy transfer or analysis.

## 📂 Output Example

C:\Forensics\2025-05-06_13-45-00
├── systeminfo.txt
├── netstat.txt
├── ScheduledTasks.txt
├── StartupItems.txt
├── SecurityLog.txt
├── ...
└── file_hashes.txt
