#!/bin/bash

# backup.sh
# Creates a timestamped backup archive of a source directory
# Deletes backups older than 14 days
# Prints archive details and handles errors

SRC_DIR="$1"
DEST_DIR="$2"

# Exit if arguments not provided
if [ $# -lt 2 ]; then
  SCRIPT_NAME=$(basename "$0")
  echo "Usage: $SCRIPT_NAME /path/to/source /path/to/destination"
  exit 1
fi

# Exit if source directory doesn't exist
if [ ! -d "$SRC_DIR" ]; then
  echo "Error: Source directory $SRC_DIR does not exist."
  exit 1
fi

# Ensure destination directory exists
mkdir -p "$DEST_DIR"

# Timestamp for archive name
TIMESTAMP=$(date +"%Y-%m-%d")
ARCHIVE_NAME="backup-$TIMESTAMP.tar.gz"
ARCHIVE_PATH="$DEST_DIR/$ARCHIVE_NAME"

# Create archive
tar -czf "$ARCHIVE_PATH" -C "$SRC_DIR" .

# Verify archive creation
if [ -f "$ARCHIVE_PATH" ]; then
  ARCHIVE_SIZE=$(du -h "$ARCHIVE_PATH" | cut -f1)
  echo "$(date +"%Y-%m-%d %H:%M:%S"): Backup created successfully."
  echo "Archive: $ARCHIVE_NAME"
  echo "Size: $ARCHIVE_SIZE"
else
  echo "Error: Backup archive was not created."
  exit 1
fi

# Delete backups older than 14 days
DELETED_COUNT=$(find "$DEST_DIR" -type f -name "backup-*.tar.gz" -mtime +14 -delete -print | wc -l)

echo "$(date +"%Y-%m-%d %H:%M:%S"): Deleted $DELETED_COUNT old backups."
