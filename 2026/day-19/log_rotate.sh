#!/bin/bash

# log_rotate.sh
# Compress .log files older than 7 days
# Delete .gz files older than 30 days
# Print summary of actions




<<EOF
# This block also allows us to confirm that a string has no content, meaning its length is zero.
if [ -z "$LOG_DIR" ]; then
  echo "Usage: $0 /path/to/log_directory"
  exit 1
fi
EOF
# To extract the basename of the script instead of printing the full path followed by name
SCRIPT_NAME=$(basename "$0")

# Exit if directory not provided
if [ $# -eq 0 ]; then
	echo "Usage: $SCRIPT_NAME /path/to/log_directory"
	exit 1
fi

LOG_DIR="$1"

# Exit if directory doesn't exist
if [ ! -d "$LOG_DIR" ]; then
  echo "Error: Directory $LOG_DIR does not exist."
  exit 1
fi

# Timestamp for logging
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Compress .log files older than 7 days
COMPRESSED_COUNT=$(find "$LOG_DIR" -type f -name "*.log" -mtime +7 -exec gzip {} \; -print | wc -l)

# Delete .gz files older than 30 days
DELETED_COUNT=$(find "$LOG_DIR" -type f -name "*.gz" -mtime +30 -delete -print | wc -l)

# Print results with timestamp
echo "$TIMESTAMP: Compressed $COMPRESSED_COUNT files, Deleted $DELETED_COUNT files"
