# Log Analyzer and Report Generator

### Task 1: Input and Validation
Your script should:
1. Accept the path to a log file as a command-line argument
2. Exit with a clear error message if no argument is provided
3. Exit with a clear error message if the file doesn't exist

```bash
if [ $# -eq 0 ]; then
    echo "Usage: $0 <log_file_path>"
    exit 1
fi

log_file="$1"

if [ ! -f "$log_file" ]; then
    echo "Error: $log_file file does not exists."
    exit 1
fi
```
---

### Task 2: Error Count
1. Count the total number of lines containing the keyword `ERROR` or `Failed`
2. Print the total error count to the console

```bash
error_count=$(grep -c "ERROR" $log_file)
echo "--- Error Count ---"
echo "Total errors found: $error_count"
```
---

### Task 3: Critical Events
1. Search for lines containing the keyword `CRITICAL`
2. Print those lines along with their line number

Example output:
```
--- Critical Events ---
Line 84: 2025-07-29 10:15:23 CRITICAL Disk space below threshold
Line 217: 2025-07-29 14:32:01 CRITICAL Database connection lost
```
```bash
echo "--- Critical Events ---"
grep -n "CRITICAL" $log_file
```
---

### Task 4: Top Error Messages
1. Extract all lines containing `ERROR`
2. Identify the **top 5 most common** error messages
3. Display them with their occurrence count, sorted in descending order

Example output:
```
--- Top 5 Error Messages ---
45 Connection timed out
32 File not found
28 Permission denied
15 Disk I/O error
9  Out of memory
```
```bash
echo "--- Top 5 Error Messages ---"
grep -i "ERROR" "$log_file" \
    | awk '{sub(/.*\[ERROR\] /,""); sub(/ - [0-9]+$/,""); print}'\
    | sort \
    | uniq -c \
    | sort -nr \
    | head -5
```
---

### Task 5: Summary Report
Generate a summary report to a text file named `log_report_<date>.txt` (e.g., `log_report_2026-02-11.txt`). The report should include:
1. Date of analysis
2. Log file name
3. Total lines processed
4. Total error count
5. Top 5 error messages with their occurrence count
6. List of critical events with line numbers

```bash
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
```
---

### Task 6 (Optional): Archive Processed Logs
Add a feature to:
1. Create an `archive/` directory if it doesn't exist
2. Move the processed log file into `archive/` after analysis
3. Print a confirmation message
```bash
archive_dir="archive"
mkdir -p "$archive_dir"
mv "$log_file" "$archive_dir/"
echo "Log file archived to $archive_dir/"
```
---

### Sample output from running against the sample log

```bash
chmod +x log_analyzer.sh
```
```bash
/log_analyzer.sh 
Usage: ./log_analyzer.sh <log_file_path>
```
```bash
./log_analyzer.sh abc.log
Error: abc.log file does not exists.
```
```bash
./log_analyzer.sh myapp.log               
--- Error Count ---
Total errors found: 38
--- Critical Events ---
3:2026-02-13 22:15:44 [CRITICAL]  - 26274
5:2026-02-13 22:15:44 [CRITICAL]  - 25826
7:2026-02-13 22:15:44 [CRITICAL]  - 17337
8:2026-02-13 22:15:44 [CRITICAL]  - 19543
12:2026-02-13 22:15:44 [CRITICAL]  - 21065
22:2026-02-13 22:15:44 [CRITICAL]  - 30484
33:2026-02-13 22:15:44 [CRITICAL]  - 1588
35:2026-02-13 22:15:44 [CRITICAL]  - 4068
42:2026-02-13 22:15:44 [CRITICAL]  - 26521
48:2026-02-13 22:15:44 [CRITICAL]  - 16219
68:2026-02-13 22:15:44 [CRITICAL]  - 20752
69:2026-02-13 22:15:44 [CRITICAL]  - 1961
74:2026-02-13 22:15:44 [CRITICAL]  - 16764
78:2026-02-13 22:15:44 [CRITICAL]  - 2305
79:2026-02-13 22:15:44 [CRITICAL]  - 9448
82:2026-02-13 22:15:44 [CRITICAL]  - 22246
84:2026-02-13 22:15:44 [CRITICAL]  - 13170
86:2026-02-13 22:15:44 [CRITICAL]  - 14412
89:2026-02-13 22:15:44 [CRITICAL]  - 5712
96:2026-02-13 22:15:44 [CRITICAL]  - 31083
106:2026-02-13 22:15:44 [CRITICAL]  - 27971
108:2026-02-13 22:15:44 [CRITICAL]  - 17727
111:2026-02-13 22:15:44 [CRITICAL]  - 12397
116:2026-02-13 22:15:44 [CRITICAL]  - 6676
118:2026-02-13 22:15:44 [CRITICAL]  - 1274
119:2026-02-13 22:15:44 [CRITICAL]  - 1300
120:2026-02-13 22:15:44 [CRITICAL]  - 26216
125:2026-02-13 22:15:44 [CRITICAL]  - 7097
128:2026-02-13 22:15:44 [CRITICAL]  - 15074
130:2026-02-13 22:15:44 [CRITICAL]  - 19108
157:2026-02-13 22:15:44 [CRITICAL]  - 22340
158:2026-02-13 22:15:44 [CRITICAL]  - 11505
167:2026-02-13 22:15:44 [CRITICAL]  - 14498
185:2026-02-13 22:15:44 [CRITICAL]  - 20735
187:2026-02-13 22:15:44 [CRITICAL]  - 479
195:2026-02-13 22:15:44 [CRITICAL]  - 29155
198:2026-02-13 22:15:44 [CRITICAL]  - 4463
--- Top 5 Error Messages ---
     11 Segmentation fault
     11 Invalid input
      7 Out of memory
      7 Failed to connect
      2 Disk full
Summary report generated: log_report_2026-02-13.txt
Log file archived to archive/
```
```bash
ls -l
total 24
drwxr-xr-x. 1 student student   18 Feb 13 22:17 archive
-rw-r--r--. 1 student student 4966 Feb 13 22:11 day-20-solution.md
-rwxr-xr-x. 1 student student 1948 Feb 13 22:13 log_analyzer.sh
-rw-r--r--. 1 student student 1863 Feb 13 22:17 log_report_2026-02-13.txt
-rw-r--r--. 1 student student 3491 Feb 13 19:26 README.md
-rwxr-xr-x. 1 student student 1101 Feb 13 19:26 sample_logs_generator.sh
```
```bash
cat log_report_2026-02-13.txt 
Log Analysis Report - 2026-02-13
Log File: myapp.log
Total Lines Processed: 200
Total Error Count: 38

--- Top 5 Error Messages ---
     11 Segmentation fault
     11 Invalid input
      7 Out of memory
      7 Failed to connect
      2 Disk full

--- Critical Events ---
3:2026-02-13 22:15:44 [CRITICAL]  - 26274
5:2026-02-13 22:15:44 [CRITICAL]  - 25826
7:2026-02-13 22:15:44 [CRITICAL]  - 17337
8:2026-02-13 22:15:44 [CRITICAL]  - 19543
12:2026-02-13 22:15:44 [CRITICAL]  - 21065
22:2026-02-13 22:15:44 [CRITICAL]  - 30484
33:2026-02-13 22:15:44 [CRITICAL]  - 1588
35:2026-02-13 22:15:44 [CRITICAL]  - 4068
42:2026-02-13 22:15:44 [CRITICAL]  - 26521
48:2026-02-13 22:15:44 [CRITICAL]  - 16219
68:2026-02-13 22:15:44 [CRITICAL]  - 20752
69:2026-02-13 22:15:44 [CRITICAL]  - 1961
74:2026-02-13 22:15:44 [CRITICAL]  - 16764
78:2026-02-13 22:15:44 [CRITICAL]  - 2305
79:2026-02-13 22:15:44 [CRITICAL]  - 9448
82:2026-02-13 22:15:44 [CRITICAL]  - 22246
84:2026-02-13 22:15:44 [CRITICAL]  - 13170
86:2026-02-13 22:15:44 [CRITICAL]  - 14412
89:2026-02-13 22:15:44 [CRITICAL]  - 5712
96:2026-02-13 22:15:44 [CRITICAL]  - 31083
106:2026-02-13 22:15:44 [CRITICAL]  - 27971
108:2026-02-13 22:15:44 [CRITICAL]  - 17727
111:2026-02-13 22:15:44 [CRITICAL]  - 12397
116:2026-02-13 22:15:44 [CRITICAL]  - 6676
118:2026-02-13 22:15:44 [CRITICAL]  - 1274
119:2026-02-13 22:15:44 [CRITICAL]  - 1300
120:2026-02-13 22:15:44 [CRITICAL]  - 26216
125:2026-02-13 22:15:44 [CRITICAL]  - 7097
128:2026-02-13 22:15:44 [CRITICAL]  - 15074
130:2026-02-13 22:15:44 [CRITICAL]  - 19108
157:2026-02-13 22:15:44 [CRITICAL]  - 22340
158:2026-02-13 22:15:44 [CRITICAL]  - 11505
167:2026-02-13 22:15:44 [CRITICAL]  - 14498
185:2026-02-13 22:15:44 [CRITICAL]  - 20735
187:2026-02-13 22:15:44 [CRITICAL]  - 479
195:2026-02-13 22:15:44 [CRITICAL]  - 29155
198:2026-02-13 22:15:44 [CRITICAL]  - 4463
```
```bash
ls -l archive 
total 8
-rw-r--r--. 1 student student 8094 Feb 13 22:15 myapp.log
```
---

### Commands/Tools Used

1. 	`grep` → filters only  lines.
2. 	`awk` → cleans each line to isolate the error message.
3. 	`sort` → prepares identical messages to be grouped.
4. 	`uniq -c` → counts occurrences of each unique message.
5. 	`sort -rn` → orders by frequency (descending).
6. 	`head -5` → outputs the top 5 most common errors.
---

### Key Takeaways from the Log Analyzer Script

1. **Input Validation Matters**  
   - Always check that a log file is provided and it exists before processing.  
   - Prevents runtime errors and ensures the script doesn’t waste resources on invalid input.

2. **Pipeline Power with Command Tools**  
   - Combining tools like `grep`, `awk`, `sort`, `uniq`, and `head` creates a powerful text‑processing pipeline.  
   - Each tool does one job well: filtering, cleaning, grouping, counting, and ranking — together they transform raw logs into meaningful insights.

3. **Flexible Error Analysis**  
   - By stripping timestamps and numeric codes, the script isolates the actual error messages.  
   - Counting and ranking them highlights the most frequent issues, which is crucial for troubleshooting and prioritizing fixes.
---
