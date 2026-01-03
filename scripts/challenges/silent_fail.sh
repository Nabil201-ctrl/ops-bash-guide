#!/bin/bash
# CHALLENGE 2: The Silent Killer
# Goal: This script runs but nothing happens. Not even an error. Why?
# Hint: Where is the output going?

TARGET_FILE="/etc/secret_config.conf"
NEW_CONFIG="enable_feature=true"

echo "Applying configuration..."

# Trying to write to a system file. 
# BUG 1: Permissions. You need sudo to write to /etc.
# BUG 2: '2>&1 >/dev/null' is hiding the Permission Denied error.
echo "$NEW_CONFIG" >> "$TARGET_FILE" 2>&1 >/dev/null

# Double check if it worked
if grep -q "enable_feature=true" "$TARGET_FILE" 2>/dev/null; then
    echo "Success!"
else
    echo "Done." # It just says Done, but it didn't do anything.
fi
