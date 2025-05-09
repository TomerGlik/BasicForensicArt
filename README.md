# 🕵️‍♂️ BasicForensicArt

PowerShell-based live response tool I built to help automate basic forensic data collection from Windows endpoints.

---

## ⚠️ Notes

- Please run **as Administrator** – script reads logs, drivers, and registry info that require elevated access.
- Nothing gets modified – it’s a read-only process that outputs to a zip archive.
- Not designed for RAM captures. Use tools like [Magnet RAM Capture](https://www.magnetforensics.com/resources/magnet-ram-capture/) for memory acquisition.
- Works great in triage, threat hunting, or "grab-and-go" IR cases where visibility is limited.

---

## 🧠 Why I Made It

This project was born out of a personal drive to learn and grow.  
It started as an idea from my manager, aimed at helping me strengthen my cybersecurity skills and demonstrate determination through hands-on experience.

---

## 💻 What It Collects

The script grabs:

- System details: hostname, users, time, local groups
- Network connections + process list
- Scheduled tasks & startup entries
- Installed applications
- Active services & drivers
- Security, System, and Application logs (last 50–1000 events)
- SHA256 file hashes from:
  - `Downloads`
  - `Desktop`
  - `Temp`

All output is stored in a timestamped folder, then zipped for easy upload or transfer.

---

## 🧪 Sample Output
C:\Forensics\ --Date Format--
- systeminfo.txt
- netstat.txt
- ScheduledTasks.txt
- StartupItems.txt
- SecurityLog.txt
- file_hashes.txt
- ...

## 🚀 Usage

```powershell
Set-ExecutionPolicy Bypass -Scope Process
.\LiveResponse.ps1
```
Plug in your USB stick, run it, wait a few minutes, and boom — zipped artifacts ready for analysis.

🧊 Final Word
This was built by a security analyst for security analysts. Feel free to fork, tweak, and adapt.
If it helped you — I’d love to hear how.
