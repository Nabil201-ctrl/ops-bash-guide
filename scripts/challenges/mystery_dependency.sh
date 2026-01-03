#!/bin/bash
# CHALLENGE 1: The Mystery Dependency
# Goal: Run this script. It will fail. Find out why and fix it.
# Hint: Look at the error message (or lack thereof).

echo "Starting backup process..."

# We want to backup the current directory
BACKUP_NAME="backup_$(date +%s).tar.gz"

# Attempting to use a super-fast compression tool I heard about
# BUG: 'pigz' is likely not installed on your system. 
# The script assumes it exists.
tar -I pigz -cf "$BACKUP_NAME" .

if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_NAME"
else
    echo "Backup failed!"
fi
