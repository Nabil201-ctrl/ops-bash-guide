#!/bin/bash

# --- CONFIGURATION ---
TARGET_SSID="MyHomeWifi"
TARGET_PASS="SecretPassword123"
CHECK_HOST="8.8.8.8" # Google's DNS server is our reference for "Internet is UP"

# --- LOGIC ---
echo "Checking internet connection..."

# 1. Ping the check host once (-c 1).
# 2. Hide valid output > /dev/null (we don't need to see the reply)
# 3. 2>&1 redirects errors to standard output (so they also get hidden)
if ping -c 1 $CHECK_HOST > /dev/null 2>&1; then
    echo "✅ Internet is ONLINE."
    exit 0 # Exit with success code (0)
else
    echo "❌ Internet is OFFLINE. Attempting fix..."
fi

# Attempt Reconnection using nmcli
# 'nmcli radio wifi off' kills the radio power to reset the hardware state
echo "Resetting WiFi adapter..."
nmcli radio wifi off
sleep 2 # Computers need time to think
nmcli radio wifi on
sleep 5 # Waiting for hardware to wake up

echo "Connecting to $TARGET_SSID..."
nmcli device wifi connect "$TARGET_SSID" password "$TARGET_PASS"

# Final Check
if ping -c 1 $CHECK_HOST > /dev/null 2>&1; then
    echo "✅ RECOVERY SUCCESSFUL."
else
    echo "💀 RECOVERY FAILED. Call the ISP."
fi
