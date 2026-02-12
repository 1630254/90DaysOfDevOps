# Shell Scripting Project: Log Rotation, Backup & Crontab

### Task 1: Log Rotation Script
Create `log_rotate.sh` that:
1. Takes a log directory as an argument (e.g., `/var/log/myapp`)
2. Compresses `.log` files older than 7 days using `gzip`
3. Deletes `.gz` files older than 30 days
4. Prints how many files were compressed and deleted
5. Exits with an error if the directory doesn't exist

```bash
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

```
```bash
chmod +x log_rotate.sh
```
```bash
./log_rotate.sh
Usage: log_rotate.sh /path/to/log_directory
./log_rotate.sh /var/log/myapp
2026-02-12 09:25:38: Compressed 2 files, Deleted 1 files
```
> Follow below section to setup directory where above script can be tested. Run this script as user - `root`

```bash
cat setup_myapp.sh 
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

```
```bash
chmod +x setup_app.sh
```
```bash
./setup_myapp.sh 
Directory /var/log/myapp does not exist. Creating...
Ownership of /var/log/myapp updated to user: student
Test files created in /var/log/myapp:
total 20K
-rw-r--r--. 1 student student 14 2026-02-02 09:23 app.log
-rw-r--r--. 1 student student 32 2026-01-18 09:23 archive.log.gz
-rw-r--r--. 1 student student 16 2026-02-12 09:23 debug.log
-rw-r--r--. 1 student student 16 2026-01-28 09:23 error.log
-rw-r--r--. 1 student student 39 2026-01-03 09:23 old.log.gz

```

---

### Task 2: Server Backup Script
Create `backup.sh` that:
1. Takes a source directory and backup destination as arguments
2. Creates a timestamped `.tar.gz` archive (e.g., `backup-2026-02-08.tar.gz`)
3. Verifies the archive was created successfully
4. Prints archive name and size
5. Deletes backups older than 14 days from the destination
6. Handles errors — exit if source doesn't exist

```bash
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
```
```bash
chmod +x backup.sh
```
```bash
/backup.sh
Usage: backup.sh /path/to/source /path/to/destination
./backup.sh /var/log/myapp /var/tmp/backup 
2026-02-12 09:28:49: Backup created successfully.
Archive: backup-2026-02-12.tar.gz
Size: 4.0K
2026-02-12 09:28:49: Deleted 0 old backups.

```
---

### Task 3: Crontab
1. Read: `crontab -l` — what's currently scheduled?
```bash
crontab -l
no crontab for student

```
2. Understand cron syntax:
   ```
   * * * * *  command
   │ │ │ │ │
   │ │ │ │ └── Day of week (0-7)
   │ │ │ └──── Month (1-12)
   │ │ └────── Day of month (1-31)
   │ └──────── Hour (0-23)
   └────────── Minute (0-59)
   ```
3. Write cron entries (in your markdown, don't apply if unsure) for:
   - Run `log_rotate.sh` every day at 2 AM
   - Run `backup.sh` every Sunday at 3 AM
   - Run a health check script every 5 minutes

```bash

# Run log_rotate.sh every day at 2 AM
0 2 * * * /home/student/90DaysOfDevOps/2026/day-19/log_rotate.sh /var/log/myapp >> /var/log/log_rotate.log 2>&1

# Run backup.sh every Sunday at 3 AM
0 3 * * 0 /home/student/90DaysOfDevOps/2026/day-19/backup.sh /var/tmp/myapp /var/tmp/backups >> /var/log/backup.log 2>&1

# Run health check script every 5 minutes
*/5 * * * * /home/student/90DaysOfDevOps/2026/day-19/health_check.sh >> /var/log/health_check.log 2>&1
```

---

### Task 4: Combine — Scheduled Maintenance Script
Create `maintenance.sh` that:
1. Calls your log rotation function
2. Calls your backup function
3. Logs all output to `/var/log/maintenance.log` with timestamps

```bash
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
```
```bash
chmod +x maintenance.sh
```
```bash
./maintenance.sh 
tail /var/tmp/maintenance.log 
2026-02-12 09:41:32: Starting log rotation...
2026-02-12 09:41:32: Compressed 0 files, Deleted 0 files
2026-02-12 09:41:32: Log rotation completed.
2026-02-12 09:41:32: Starting backup...
2026-02-12 09:41:32: Backup created successfully.
Archive: backup-2026-02-12.tar.gz
Size: 4.0K
2026-02-12 09:41:32: Deleted 0 old backups.
2026-02-12 09:41:32: Backup completed.
2026-02-12 09:41:32: Maintenance tasks finished.
```
4. Write the cron entry to run it daily at 1 AM
```bash
0 1 * * * /home/student/90DaysOfDevOps/2026/day-19/maintenance.sh
```
---

## What I learned

**1. Argument Validation and Error Handling**
- Always check if required arguments are provided (`[ $# -eq 0 ]`) and whether directories exist (`[ -d "$DIR" ]`).
- Exit gracefully with clear usage messages when conditions aren’t met.
- This prevents scripts from running blindly and avoids destructive or confusing behavior.

**2. Timestamping and Logging**
- Use `date +"%Y-%m-%d %H:%M:%S"` for consistent timestamps.
- Append logs with `>> logfile 2>&1` so both standard output and errors are captured.
- This makes scripts auditable and easier to troubleshoot later.

**3. Ownership and Permissions**
- Privilege checks (`id -u`) prevent non‑root users from running sensitive operations.
- Recursive ownership updates with `chown -R "$USER":"$USER" "$DIR"` let you control who owns files.
- This is critical for maintaining security and ensuring the right user has access to generated files.
---