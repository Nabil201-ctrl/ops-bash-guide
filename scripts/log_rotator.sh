#!/bin/bash

LOG_FILE="/var/log/myapp.log"
BACKUP_DIR="/var/log/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S") # e.g., 20231025_143000

# check if file exists and is larger than 10MB
# -s check if file exists and size > 0
# $(du -m ...) gets size in Megabytes
FILE_SIZE=$(du -m "$LOG_FILE" | cut -f1)

if [ -f "$LOG_FILE" ] && [ "$FILE_SIZE" -gt 10 ]; then
    echo "Log is too big ($FILE_SIZE MB). Rotating..."
    
    # Create backup folder if not exists (-p)
    mkdir -p "$BACKUP_DIR"
    
    # Compressing the file
    # tar -czf [archive_name] [file_to_zip]
    tar -czf "$BACKUP_DIR/log_$TIMESTAMP.tar.gz" "$LOG_FILE"
    
    # Truncate the original file to 0 bytes
    > "$LOG_FILE"
    
    echo "Log rotated."
else
    echo "Log size is fine ($FILE_SIZE MB)."
fi
