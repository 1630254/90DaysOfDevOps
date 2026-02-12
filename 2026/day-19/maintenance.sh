#!/bin/bash

# maintenance.sh
# Runs log rotation and backup tasks
# Logs all output to /var/log/maintenance.log with timestamps

LOG_FILE="/var/tmp/maintenance.log"
LOG_DIR="/var/log/myapp"
SRC_DIR="/var/log/myapp"
DEST_DIR="/var/tmp/backup"

# Function to log messages with timestamp
log_message() {
  echo "$(date +"%Y-%m-%d %H:%M:%S"): $1" >> "$LOG_FILE"
}

# Run log rotation
log_message "Starting log rotation..."
./log_rotate.sh "$LOG_DIR" >> "$LOG_FILE" 2>&1
log_message "Log rotation completed."

# Run backup
log_message "Starting backup..."
./backup.sh "$SRC_DIR" "$DEST_DIR" >> "$LOG_FILE" 2>&1
log_message "Backup completed."

log_message "Maintenance tasks finished."
