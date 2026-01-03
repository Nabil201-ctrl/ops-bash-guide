# 🦅 The Primitive to God-Tier Bash Mastery Guide

Welcome. This guide is designed to take you from knowing nothing about the terminal to building your own cloud infrastructure automation. We break everything down to the "primitive level"—understanding *how* it works, not just memorizing commands.

---

## 📚 Table of Contents
1.  **The Primitive Mindset**: Understanding the Shell
2.  **Level 1: Foundations**: Filesystem, Permissions & The "Everything is a File" Philosophy
3.  **Level 2: Connectivity**: Networking, WiFi, Bluetooth, and DNS
4.  **Level 3: System Control**: Mounts, Services, & Updates
5.  **Level 4: Text Processing**: The Art of Data Manipulation (grep, awk, sed)
6.  **Level 5: Automation**: Scripting, Loops, & Cron
7.  **Level 6: Infrastructure**: SSH, Firewalls, & Cloud Init
8.  **Level 7: The Exam**: Projects & Diagnostics
9.  **Level 8: The Debugger's Dungeon**: Advanced Troubleshooting challenges

---

## 🧠 1. The Primitive Mindset: Understanding the Shell
Computers are dumb. They process `0`s and `1`s. The **Shell (Bash)** is the bridge between your human language and the computer's kernel.
When you type `ls`, you aren't "looking" at a folder. You are asking a program called `ls` to read the directory file and print the names inside it to your screen (Standard Output).

**Key Concept**:
- **STDIN (0)**: Standard Input (Keyboard/Data in)
- **STDOUT (1)**: Standard Output (Screen/Data out)
- **STDERR (2)**: Standard Error (Error messages)

---

## 🧱 2. Level 1: Foundations

### The Filesystem Tree
Linux is a tree. It starts at `/` (Root).
- `/bin`: Binaries (Programs like `ls`, `mkdir`)
- `/etc`: Etcetera (Configuration files)
- `/home`: Users' personal files
- `/dev`: Devices (Hard drives, mouse, webcam)

### Navigation & Manipulation
| Command | Primitive Meaning | Example |
| :--- | :--- | :--- |
| `pwd` | "Where am I in the tree?" | `pwd` |
| `cd` | "Move to branch X" | `cd /etc` |
| `ls -la` | "List everything, even hidden secrets" | `ls -la` |
| `mkdir` | "Make a new directory node" | `mkdir projects` |
| `touch` | "Create empty file OR update timestamp" | `touch file.txt` |
| `cp -r` | "Copy recursively (folder + contents)" | `cp -r folder/ backup/` |
| `rm -rf` | "Remove recursively and forcedly (DANGEROUS)" | `rm -rf bad_folder` |

### Permissions: Who owns the tree?
Every file has 3 groups of permissions: **U**ser (Owner), **G**roup, **O**thers.
Read (`r`=4), Write (`w`=2), Execute (`x`=1).

**The Magic Command: `chmod`**
- `chmod 777 file`: Everyone can do everything (4+2+1 for everyone). **Don't do this.**
- `chmod +x script.sh`: Make it executable (runnable program).
- `chown user:group file`: Change the owner.

**Primitive Exercise:**
1. Create a folder named `secret_base`.
2. Create a file inside called `plans.txt`.
3. Lock it so *only you* can read/write it (Hint: `chmod 600`).

---

## 📡 3. Level 2: Connectivity & Networking

The cloud is just other people's computers connected by wires/waves. You must master the connection.

### The ID Card: IP Addresses
- **Loopback (`127.0.0.1`)**: "Me".
- **LAN IP (`192.168.x.x` etc)**: Your address in the room.
- **WAN IP**: Your address on the internet.

**Tools:**
- `ip a`: The modern way to see interfaces. Look for `eth0` (wired) or `wlan0` (wifi).
- `ping google.com`: "Are you there?" (Check internet).
- `ping 8.8.8.8`: "Is Google's IP there?" (Check if DNS is broken).

### WiFi Configuration (`nmcli`)
Forget GUIs. Use **NetworkManager Command Line Interface**.
1. **Turn on Wifi**: `nmcli radio wifi on`
2. **Scan**: `nmcli device wifi list`
3. **Connect**: `nmcli device wifi connect "SSID_NAME" password "YOUR_PASSWORD"`

### 🧪 Practical Code Lab: The WiFi Auto-Connector
A script that detects if you are offline and tries to reconnect.

🔗 **[View Script: scripts/wifi_fixer.sh](scripts/wifi_fixer.sh)**

### Bluetooth (`bluetoothctl`)
1. Enter controller: `bluetoothctl`
2. Turn on: `power on`
3. Scan: `scan on`
4. Pair: `pair AA:BB:CC:DD:EE:FF`
5. Connect: `connect AA:BB:CC:DD:EE:FF`

### DNS: The Phonebook
When you type `google.com`, your computer asks a DNS server for the IP.
- **Config file**: `/etc/resolv.conf`
- **Test it**: `nslookup google.com` or `dig google.com`

**Diagnostic Workflow:**
1. Can you ping `8.8.8.8`? -> Yes? Internet works. No? Cable/Wifi broken.
2. Can you ping `google.com`? -> No? DNS is broken. Edit `/etc/resolv.conf` and add `nameserver 1.1.1.1`.

---

## ⚙️ 4. Level 3: System Admin & Control

### Mounting: Plugging things in
When you plug in a USB, Linux doesn't just "show" it. You must **Mount** it to a directory.
1. **Find it**: `lsblk` (List Block Devices). Say it's `/dev/sdb1`.
2. **Make a door**: `sudo mkdir /mnt/usb`
3. **Mount it**: `sudo mount /dev/sdb1 /mnt/usb`
4. **Unplug**: `sudo umount /mnt/usb`

**fstab**: To mount automatically at boot, we edit `/etc/fstab`.
*Warning: If you mess this up, your computer won't boot.*
Structure: `[Device] [MountPoint] [Type] [Options] [Dump] [Pass]`

### 🧪 Practical Code Lab: The Server Caretaker
Automated maintenance script for updating packages and cleaning logs.

🔗 **[View Script: scripts/maintain.sh](scripts/maintain.sh)**

### Processes & Services (systemd)
- **Top**: Type `htop` (or `top`) to see what's running. Control+C to exit.
- **Kill**: `kill -9 [PID]` (Force kill a Process ID).
- **Services**: Long-running background programs (like a web server).
    - `systemctl status nginx`: Is it running?
    - `systemctl start nginx`: Start it.
    - `systemctl enable nginx`: Start it closely on boot.
    - `journalctl -u nginx -f`: Watch the logs live (Tail).

---

## 📜 5. Level 4: Text Processing & Scripting

The superpower of Bash is piping `|`. You can take the output of one command and throw it into another.

### The Holy Trinity: Grep, Awk, Sed
1.  **Grep (Global Regular Expression Print)**: Search for text.
    - `cat huge_log.txt | grep "ERROR"`: Show only error lines.
    - `grep -r "TODO" .`: Search for "TODO" in all files recursively.
2.  **Awk**: Scan columns.
    - `ls -l | awk '{print $1, $9}'`: Print only permissions (col 1) and filename (col 9).
3.  **Sed (Stream Editor)**: Find and replace.
    - `cat config.txt | sed 's/false/true/'`: Replace "false" with "true" (visual only).
    - `sed -i 's/false/true/' config.txt`: Save the change to the file.

### Bash Scripting Basics & Loops
A script is just a file with commands.
Start with: `#!/bin/bash` (The Shebang).

**Variables**:
```bash
NAME="Neo"
echo "Hello, $NAME"
```

**Loops**: Do something many times.
```bash
# Ping 3 servers
for ip in 192.168.1.1 192.168.1.2 8.8.8.8; do
    ping -c 1 $ip
done
```

**Conditions**:
```bash
if [ -f "/etc/passwd" ]; then
    echo "File exists!"
else
    echo "Panic mode."
fi
```

### 🧪 Practical Code Lab: The Log Rotator
Imagine your app creates a log file that gets too big. This script archives it.

🔗 **[View Script: scripts/log_rotator.sh](scripts/log_rotator.sh)**

---

## ☁️ 6. Level 5: Automation & Cloud Infrastructure

### Cron: The Time Traveller
Run scripts automatically at specific times.
- **Edit**: `crontab -e`
- **Syntax**: `Minute Hour Day Month Weekday Command`
- **Example**: Run backup at 3 AM every day.
  `0 3 * * * /home/user/backup.sh`

### SSH: The Teleporter
Secure Shell allows you to log into remote servers.
- **Connect**: `ssh user@192.168.1.50`
- **Keys (No more passwords)**:
    1. `ssh-keygen`: Generates a public (`id_rsa.pub`) and private (`id_rsa`) key.
    2. `ssh-copy-id user@192.168.1.50`: Copies your public key to the server.
    3. Now you can log in without a password. Useful for automation!

### Cloud Init: The Blueprint
When you spin up a VPS (AWS/DigitalOcean), **Cloud-Init** runs once to set it up.

### 🧪 Practical Code Lab: Cloud-Init Deep Dive
This `user-data` file builds a web server automatically when the server is born.

🔗 **[View Config: scripts/cloud_init.yaml](scripts/cloud_init.yaml)**

### 🧪 Practical Code Lab: The "Provisioner" Script
If you can't use Cloud-Init, write a Bash script to do it. This script sets up a production-ready environment.

🔗 **[View Script: scripts/provision.sh](scripts/provision.sh)**

---

## 🛡️ 7. Level 6: Security & Diagnostics

### Firewalls (UFW)
Uncomplicated Firewall. Lock your doors.
1. `sudo ufw status`: Check status.
2. `sudo ufw allow 22`: Allow SSH (CRITICAL before turning on!).
3. `sudo ufw allow 80`: Allow Web.
4. `sudo ufw enable`: Turn it on.

### Netcat (nc): The Swiss Army Knife
- **Chat**: 
  - Server: `nc -l -p 1234`
  - Client: `nc [SERVER_IP] 1234`
- **Transfer File**:
  - Server: `nc -l -p 1234 > received_file`
  - Client: `nc [SERVER_IP] 1234 < file_to_send`

### Debugging Scripts
If your script is broken, run it with `-x` to see every step.
`bash -x ./myscript.sh`

---

## 🎓 8. Level 7: The Exam (Mega-Edition)

### Part 1: Fill in the Blanks (10 Questions)
*Test your command memory.*

1.  List files including hidden ones: `ls -__`
2.  Check the current directory path: `___`
3.  Change permission to executable: `_____ +x run.sh`
4.  Show the content of a file: `___ filename.txt`
5.  Search for "error" in a log file: `grep "error" ____.log`
6.  Look at the kernel messages log: `dmesg | ____` (Hint: page by page)
7.  Check your IP address: `__ a`
8.  Download a file from an URL: `____ https://example.com/file`
9.  Run a command as superuser: `____ apt update`
10. Send output to a file (overwrite): `echo "hello" _ file.txt`

### Part 2: Bug Hunter - Fix the Code (10 Questions)
*Each snippet has ONE error. Find it.*

1.  `if [ $i = 10 ]`: Correct syntax is `if [ "$i" -eq 10 ]` (for numbers).
2.  `cp folder backup`: Error: omitting directory? Need `cp -r`.
3.  `var = "hello"`: Error: Spaces around `=`. Fix: `var="hello"`.
4.  `echo $USER`: (Correct? Yes, but better `echo "$USER"`).
5.  `for i in {1..10} do`: Missing semicolon/newline. `for i in {1..10}; do`.
6.  `cat file | grep text`: Useless cat. Fix: `grep text file`.
7.  `./script.sh`: "Permission denied"? Fix: `chmod +x script.sh`.
8.  `ping google.com`: "Unknown host"? Check DNS/Internet.
9.  `while x < 10`: Bash isn't Python. `while [ "$x" -lt 10 ]; do`.
10. `rm -rf /`: **DO NOT FIX THIS. DO NOT RUN THIS.** (The error is it destroys your life).

### Part 3: Practical Mini-Tasks (10 Missions)
*Do these in your terminal now.*

1.  **The Architect**: Create a folder structure `project/src/assets` in one command (`mkdir -p`).
2.  **The Locksmith**: Create a file `secret.txt` and make it readable ONLY by you (`chmod 600`).
3.  **The Reporter**: Save your current process list to `processes.txt` (`ps aux > processes.txt`).
4.  **The Searcher**: Find all files ending in `.log` in `/var/log` (`find /var/log -name "*.log"`).
5.  **The Networker**: Ping `8.8.8.8` exactly 4 times (`ping -c 4 8.8.8.8`).
6.  **The Archivist**: Zip your `project` folder into `project.tar.gz` (`tar -czf`).
7.  **The Scheduler**: Write a cron job line that runs `update.sh` every Monday at 8 AM.
8.  **The Investigator**: Find which process is using port 80 or 22 (`lsof -i :22` or `netstat`).
9.  **The Cleaner**: Delete all empty directories in the current folder.
10. **The Watchman**: Watch the last 10 lines of `syslog` in real-time (`tail -f /var/log/syslog`).

---

## 🪲 9. Level 8: The Debugger's Dungeon

Welcome to the hardest part. Real-world scripting is mostly fixing broken things.
I have created 3 evil scripts with hidden bugs. Can you fix them?

### The Toolkit
1. **Debug Mode**: Run with `bash -x script.sh` to see every line execute.
2. **Error Codes**: Check `echo $?` after a command to see if it failed (non-zero output).
3. **Existence Check**: Use `command -v [prog_name]` to see if a program is installed.

### 💀 The Challenges

#### Challenge 1: The Mystery Dependency
This script fails immediately. Why?
🔗 **[scripts/challenges/mystery_dependency.sh](scripts/challenges/mystery_dependency.sh)**

#### Challenge 2: The Silent Killer
This script runs without error, but does nothing. Uncover the silence.
🔗 **[scripts/challenges/silent_fail.sh](scripts/challenges/silent_fail.sh)**

#### Challenge 3: The Ghost Variable
This script counts files, but the result is always 0. A classic Bash trap.
🔗 **[scripts/challenges/loop_logic_bug.sh](scripts/challenges/loop_logic_bug.sh)**

---
*End of Guide. Now go forth and automate.*
