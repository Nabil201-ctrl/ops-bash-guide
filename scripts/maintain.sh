#!/bin/bash
# Must be run as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root (sudo)"
  exit
fi

echo "--- STARTING SYSTEM MAINTENANCE ---"

# 1. Update the package list (download latest catalog)
echo "Updating package lists..."
apt-get update -y 

# 2. Upgrade installed packages (install new versions)
# -y means "Say Yes to all prompts"
echo "Upgrading software..."
apt-get upgrade -y

# 3. Clean up junk
# 'autoremove' deletes dependencies that are no longer needed
echo "Removing unused dependencies..."
apt-get autoremove -y

# 4. Clean up apt cache (freed downloaded installer files)
echo "Cleaning installer cache..."
apt-get clean

# 5. Check disk usage
echo "--- DISK USAGE STATUS ---"
# df -h : Disk Free in Human readable (GB/MB) format
df -h | grep "^/dev/" 

echo "--- MAINTENANCE COMPLETE ---"
