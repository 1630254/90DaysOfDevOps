#!/bin/bash

# setup_myapp.sh
# Creates /var/log/myapp with test files
# Updates ownership recursively to TARGET_USER

ID=$(id -u "$(whoami)")
if [[ $ID != 0 ]]; then
    echo "WARNING!! This script requires root privilege.."
    exit 1
fi

APP_DIR="/var/log/myapp"
TARGET_USER="student"   # <-- Change this username as needed

# Check if directory exists
if [ ! -d "$APP_DIR" ]; then
    echo "Directory $APP_DIR does not exist. Creating..."
    mkdir -p "$APP_DIR"
else
    echo "Directory $APP_DIR already exists."
fi

# Create fresh log file
echo "Fresh log entry" > "$APP_DIR/debug.log"

# Create 10-day old log file
echo "Old log entry" > "$APP_DIR/app.log"
touch -d "10 days ago" "$APP_DIR/app.log"

# Create 15-day old log file
echo "Error log entry" > "$APP_DIR/error.log"
touch -d "15 days ago" "$APP_DIR/error.log"

# Create 25-day old compressed file
echo "Archive log" | gzip > "$APP_DIR/archive.log.gz"
touch -d "25 days ago" "$APP_DIR/archive.log.gz"

# Create 40-day old compressed file
echo "Old compressed log" | gzip > "$APP_DIR/old.log.gz"
touch -d "40 days ago" "$APP_DIR/old.log.gz"

# Update ownership recursively
chown -R "$TARGET_USER":"$TARGET_USER" "$APP_DIR"

echo "Ownership of $APP_DIR updated to user: $TARGET_USER"
echo "Test files created in $APP_DIR:"
ls -lh --time-style=long-iso "$APP_DIR"
