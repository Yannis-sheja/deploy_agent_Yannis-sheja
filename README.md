* deploy_agent_Yannis-sheja

* Student Attendance Tracker — Project Factory Script

This repository contains `setup_project.sh`, a shell script that automates
the creation of a workspace for the Student Attendance Tracker application.


*How to Run the Script

*Prerequisites
- Ubuntu, WSL (Windows Subsystem for Linux), or any Linux terminal
- `bash` (pre-installed on all Linux systems)
- `python3` (recommended; script will warn if missing)

Step 1 — Cloning the Repository

```bash
git clone https://github.com/YourUsername/deploy_agent_YourUsername.git
cd deploy_agent_YourUsername
```

Step 2 — Make the Script Executable by using Permission command( chmod )

```bash
chmod +x setup_project.sh
```

Step 3 — Run the Script by using bash or (./)

```bash
./setup_project.sh
```
*How to Trigger the archive
Press Ctrl+ c to trigger the cleanup function or the signal trap 

The script will:
1. Ask you for a project name (e.g., `semester1`)
2. Create the directory `attendance_tracker_semester1/` with the full structure
3. Ask if you want to update attendance thresholds
4. Edit `config.json` using `sed` if you choose to update
5. Verify Python3 is installed and all files are present

*Directory Structure Created
attendance_tracker_{input}/
├── attendance_checker.py
├── Helpers/
│   ├── assets.csv
│   └── config.json
└── reports/
└── reports.log
---

** How to Trigger the Archive Feature (SIGINT / Ctrl+C)

The script includes a Signal Trap for SIGINT (Ctrl+C).

To trigger it:
1. Run the script: `./setup_project.sh`
2. When it is prompted (e.g., for project name or thresholds), press the Ctrl+C key 

This is What happens:
- The script catches the interrupt signal
- It archives the current state of the project directory into `attendance_tracker_{input}_archive.tar.gz`
- It deletes the incomplete project directory
- It exits cleanly

This ensures no broken or incomplete directories are left behind.

---

The Files in This Repository

| File | Description |
| `setup_project.sh` | The bootstrapping script |
| `attendance_checker.py` | Python app source code |
| `assets.csv` | Sample student attendance data |
| `config.json` | Threshold configuration |
| `reports.log` | Log file template |
| `README.md` | This file |

EOF
