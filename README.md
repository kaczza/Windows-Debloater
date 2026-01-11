

# 🟠 Windows Debloater & Optimization Tool

[![PowerShell](https://img.shields.io/badge/PowerShell-7.3-blue?logo=powershell&logoColor=white)](https://github.com/powershell/powershell) 
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE) 
[![Issues](https://img.shields.io/github/issues/kaczza/Windows-Debloater)](https://github.com/yourusername/WindowsDebloater/issues)

A **user-friendly Windows debloater** with optional optimizations and privacy tweaks. Remove unnecessary apps, disable ads, tweak performance, and apply privacy settings with a clean GUI or a single PowerShell command.  

> ⚠️ **Warning:** This script makes system-level changes. Always run as Administrator and create a restore point before using.

---

## 🌟 Features

- Remove pre-installed Windows bloatware (Xbox, Cortana, Sticky Notes, and more)  
- Disable Windows Ads & Suggestions  
- Disable Windows Defender (registry tweak)  
- Disable Core Isolation / Memory Integrity  
- Apply a **Performance-Optimized Power Plan**  
- Disable Telemetry & Windows Tips  
- Create a System Restore Point before making changes  
- Logging for all actions  
- Clean GUI with hover effects and coral-orange theme  

---

## 📸 Screenshots

![Screenshot 1](./screenshots/gui1.png)  
![Screenshot 2](./screenshots/gui2.png)  

---

## ⚡ Usage

### 1. GUI Method

1. Download `Debloater.ps1` from this repository.  
2. Right-click → **Run as Administrator**.  
3. Check the options you want and click **Run Debloater**.  
4. A log window will show progress. A restart is recommended after the process.  

### 2. Command-Line

```powershell
powershell.exe -ExecutionPolicy Bypass -File "C:\Path\To\Debloater.ps1"
````
---

### Or Online Execution

```powershell
irm "https://raw.githubusercontent.com/kaczza/Windows-Debloater/main/Debloater.ps1" | iex
```

---

## 🛠️ Recommended Before Running

* Create a **System Restore Point** (option available in GUI).
* Close unnecessary apps.
* Backup important data — the script removes built-in apps and tweaks system settings.

---

## 📌 Contributing

Contributions, suggestions, and bug reports are welcome!

1. Fork the repository
2. Create a new branch (`git checkout -b feature/my-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/my-feature`)
5. Open a pull request

---

## 📄 License

This project is released under the **MIT License**. See [LICENSE](LICENSE) for details.

---

## 🧩 Optional Enhancements

* Add additional bloatware removal options
* Add more performance tweaks or privacy optimizations
* Host your script online for single-command execution
* Add automatic updates for the script

---

## ❤️ Support / Links

* GitHub: [https://github.com/kaczza/Windows-Debloater](https://github.com/yourusername/WindowsDebloater)
* Issues / Feedback: [https://github.com/kaczza/Windows-Debloater/issues](https://github.com/yourusername/WindowsDebloater/issues)

---

> Made with ❤️ for power users who want a cleaner, faster Windows experience.
