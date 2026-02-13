#!/bin/bash
# log_analyzer.sh
# A script to analyze log files for errors and critical events

# -----------------------------
# Task 1: Input and Validation
# -----------------------------
if [ $# -eq 0 ]; then
    echo "Usage: $0 <log_file_path>"
    exit 1
fi

log_file="$1"

if [ ! -f "$log_file" ]; then
    echo "Error: $log_file file does not exists."
    exit 1
fi

# -----------------------------
# Task 2: Error Count
# -----------------------------
error_count=$(grep -c "ERROR" $log_file)
echo "--- Error Count ---"
echo "Total errors found: $error_count"

# -----------------------------
# Task 3: Critical Events
# -----------------------------
echo "--- Critical Events ---"
grep -n "CRITICAL" $log_file

# -----------------------------
# Task 4: Top Error Messages
# -----------------------------
echo "--- Top 5 Error Messages ---"
grep -i "ERROR" "$log_file" \
    | awk '{sub(/.*\[ERROR\] /,""); sub(/ - [0-9]+$/,""); print}'\
    | sort \
    | uniq -c \
    | sort -nr \
    | head -5

# -----------------------------
# Task 5: Summary Report
# -----------------------------
report_date=$(date +%Y-%m-%d)
report_file="log_report_${report_date}.txt"

{
    echo "Log Analysis Report - $report_date"
    echo "Log File: $log_file"
    echo "Total Lines Processed: $(wc -l < "$log_file")"
    echo "Total Error Count: $error_count"
    echo
    echo "--- Top 5 Error Messages ---"
    grep -i "ERROR" "$log_file" \
    	| awk '{sub(/.*\[ERROR\] /,""); sub(/ - [0-9]+$/,""); print}'\
        | sort \
        | uniq -c \
        | sort -nr \
        | head -5
    echo
    echo "--- Critical Events ---"
    grep -n "CRITICAL" $log_file

} > "$report_file"

echo "Summary report generated: $report_file"

# -----------------------------
# Task 6 (Optional): Archive Processed Logs
# -----------------------------
archive_dir="archive"
mkdir -p "$archive_dir"
mv "$log_file" "$archive_dir/"
echo "Log file archived to $archive_dir/"
