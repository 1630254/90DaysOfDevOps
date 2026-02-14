#  Shell Scripting Cheat Sheet: Build Your Own Reference Guide


### Task 1: Basics
Document the following with short descriptions and examples:
1. Shebang (`#!/bin/bash`) — what it does and why it matters
2. Running a script — `chmod +x`, `./script.sh`, `bash script.sh`
3. Comments — single line (`#`) and inline
4. Variables — declaring, using, and quoting (`$VAR`, `"$VAR"`, `'$VAR'`)
5. Reading user input — `read`
6. Command-line arguments — `$0`, `$1`, `$#`, `$@`, `$?`
---

- **1. Shebang (`#!/bin/bash`)**

Tells the system which interpreter to use.
```bash
#!/bin/bash
echo "Hello World"
```
---

- **2. Running a Script**

Make executable:
```bash
chmod +x script.sh
```

Run directly:
```bash
./script.sh
```

Run with interpreter:
```bash
bash script.sh
```
---

- **3. Comments**

Single line:
```bash
# This is a comment
```

Inline:
```bash
echo "Hello" # Prints Hello
```
Multiline:
```bash
<<EOF
This 
is a 
multiline comment
EOF
```
---

- **4. Variables**

Declare & use:
```bash
VAR="World"
echo $VAR
```

Quoting:
```bash
echo "$VAR"   # expands
echo '$VAR'   # literal
```
---

- **5. Reading User Input**
```bash
read NAME
echo "Hello $NAME"
```
---

- **6. Command-line Arguments**

Script name:
```bash
echo $0
```

First argument:
```bash
echo $1
```

Number of args:
```bash
echo $#
```

All args:
```bash
echo $@
```

Exit status of last command:
```bash
echo $?
```
---


### Task 2: Operators and Conditionals

Document with examples:
1. String comparisons — `=`, `!=`, `-z`, `-n`
2. Integer comparisons — `-eq`, `-ne`, `-lt`, `-gt`, `-le`, `-ge`
3. File test operators — `-f`, `-d`, `-e`, `-r`, `-w`, `-x`, `-s`
4. `if`, `elif`, `else` syntax
5. Logical operators — `&&`, `||`, `!`
6. Case statements — `case ... esac`
---

- **1. String Comparisons**

Equal (`=`):
```bash
if [ "$a" = "$b" ]; then echo "Equal"; fi
```
Not equal (`!=`):
```bash
if [ "$a" != "$b" ]; then echo "Not Equal"; fi
```

Empty string (`-z`):
```bash
if [ -z "$a" ]; then echo "Empty"; fi
```

Non-empty string (`-n`):
```bash
if [ -n "$a" ]; then echo "Not Empty"; fi
```

---

- **2. Integer Comparisons**

Equal (`-eq`):
```bash
if [ $a -eq $b ]; then echo "Equal"; fi
```

Not equal (`-ne`):
```bash
if [ $a -ne $b ]; then echo "Not Equal"; fi
```

Less than (`-lt`):
```bash
if [ $a -lt $b ]; then echo "Less"; fi
```

Greater than (`-gt`):
```bash
if [ $a -gt $b ]; then echo "Greater"; fi
```

Less or equal (`-le`):
```bash
if [ $a -le $b ]; then echo "Less/Equal"; fi
```

Greater or equal (`-ge`):
```bash
if [ $a -ge $b ]; then echo "Greater/Equal"; fi
```
---

- **3. File Test Operators**

Regular file (`-f`):
```bash
if [ -f file.txt ]; then echo "File exists"; fi
```

Directory (`-d`):
```bash
if [ -d /path ]; then echo "Directory exists"; fi
```

Exists (`-e`):
```bash
if [ -e file.txt ]; then echo "Exists"; fi
```

Readable (`-r`):
```bash
if [ -r file.txt ]; then echo "Readable"; fi
```

Writable (`-w`):
```bash
if [ -w file.txt ]; then echo "Writable"; fi
```

Executable (`-x`):
```bash
if [ -x script.sh ]; then echo "Executable"; fi
```

Non-empty (`-s`):
```bash
if [ -s file.txt ]; then echo "Not empty"; fi
```
---

- **4. `if`, `elif`, `else` Syntax**

```bash
if [ $a -gt 10 ]; then
  echo "Greater than 10"
elif [ $a -eq 10 ]; then
  echo "Equal to 10"
else
  echo "Less than 10"
fi
```
---

- **5. Logical Operators**

AND (&&):
```bash
if [ $a -gt 0 ] && [ $b -gt 0 ]; then echo "Both positive"; fi
```

OR (||):
```bash
if [ $a -eq 0 ] || [ $b -eq 0 ]; then echo "One is zero"; fi
```

NOT (!):
```bash
if [ ! -f file.txt ]; then echo "File missing"; fi
```

---

- **6. Case Statements**

```bash
case $var in
  start)
    echo "Starting..."
    ;;
  stop)
    echo "Stopping..."
    ;;
  *)
    echo "Unknown option"
    ;;
esac
```
---

### Task 3: Loops
Document with examples:
1. `for` loop — list-based and C-style
2. `while` loop
3. `until` loop
4. Loop control — `break`, `continue`
5. Looping over files — `for file in *.log`
6. Looping over command output — `while read line`

---

- **1. `for` Loop**

-   *List-based*:
```bash
for item in apple banana cherry; do
  echo $item
done
```
- *C-style:*
```bash
for ((i=1; i<=5; i++)); do
  echo $i
done
```
---

- **2. `while` Loop**
```bash
Runs while condition is true.
count=1
while [ $count -le 5 ]; do
  echo $count
  ((count++))
done
```
---

- **3. `until` Loop**
```bash
Runs until condition becomes true.
count=1
until [ $count -gt 5 ]; do
  echo $count
  ((count++))
done
```
---

- **4. Loop Control**
- **Break**: exit loop early
```bash
for i in {1..5}; do
  if [ $i -eq 3 ]; then break; fi
  echo $i
done
```

- **Continue**: skip current iteration
```bash
for i in {1..5}; do
  if [ $i -eq 3 ]; then continue; fi
  echo $i
done
```
---

- **5. Looping Over Files**
```bash
for file in *.log; do
  echo "Processing $file"
done
```
---

- **6. Looping Over Command Output**
```bash
ls -1 | while read line; do
  echo "File: $line"
done
```
---

### Task 4: Functions
Document with examples:
1. Defining a function — `function_name() { ... }`
2. Calling a function
3. Passing arguments to functions — `$1`, `$2` inside functions
4. Return values — `return` vs `echo`
5. Local variables — `local`

---

- **1. Defining a Function**
```bash
my_function() {
  echo "Hello from function"
}
```
---

- **2. Calling a Function**
```bash
my_function
```
---

- **3. Passing Arguments to Functions**
```bash
greet() {
  echo "Hello $1, you are $2 years old"
}

greet "Alice" 25
```
• `$1`, `$2` represent positional arguments inside the function.

---

- **4. Return Values**

• 	**Using** `return` (numeric exit code):
```bash
check_even() {
  if [ $(( $1 % 2 )) -eq 0 ]; then
    return 0   # success
  else
    return 1   # failure
  fi
}

check_even 4
echo $?   # prints 0
```
• 	**Using** `echo`  (output value):
```bash
add() {
  echo $(( $1 + $2 ))
}

result=$(add 3 5)
echo $result   # prints 8
```
---

- **5. Local Variables**

```bash
demo() {
  local msg="Local scope"
  echo $msg
}

demo
echo $msg   # empty, not accessible outside
```
---

### Task 5: Text Processing Commands
Document the most useful flags/patterns for each:
1. `grep` — search patterns, `-i`, `-r`, `-c`, `-n`, `-v`, `-E`
2. `awk` — print columns, field separator, patterns, `BEGIN/END`
3. `sed` — substitution, delete lines, in-place edit
4. `cut` — extract columns by delimiter
5. `sort` — alphabetical, numerical, reverse, unique
6. `uniq` — deduplicate, count
7. `tr` — translate/delete characters
8. `wc` — line/word/char count
9. `head` / `tail` — first/last N lines, follow mode

---

- **1. `grep` — Search Patterns**

Case-insensitive:
```bash
grep -i "error" logfile.txt
```
Recursive search:

```bash
grep -r "TODO" src/
```
Count matches:

```bash
grep -c "fail" logfile.txt
```

Show line numbers:
```bash
grep -n "main" code.c
```

Invert match:
```bash
grep -v "success" logfile.txt
```

Extended regex:
```bash
grep -E "error|fail" logfile.txt
```

---

- **2. `awk` — Text Processing**

Print columns:

```bash
awk '{print $1, $3}' data.txt
```

Field separator:

```bash
awk -F, '{print $2}' file.csv
```

Pattern match:

```bash
awk '/error/ {print $0}' logfile.txt
```

BEGIN/END blocks:

```bash
awk 'BEGIN {print "Start"} {print $1} END {print "Done"}' data.txt
```

---

- **3. `sed` — Stream Editor**

Substitution:

```bash
sed 's/error/warning/g' logfile.txt
```

Delete lines:

```bash
sed '/DEBUG/d' logfile.txt
```

In-place edit:

```bash
sed -i 's/foo/bar/g' file.txt
```
---

- **4. `cut` — Extract Columns**

```bash
cut -d, -f2 file.csv
```

Extracts the 2nd column using `,` as delimiter.

---

- **5. `sort` — Sorting**

Alphabetical:

```bash
sort names.txt
```


Numerical:

```bash
sort -n numbers.txt
```


Reverse:

```bash
sort -r names.txt
```


Unique:

```bash
sort -u names.txt
```


---

- **6. `uniq` — Deduplicate**

Remove duplicates:

```bash
uniq sorted.txt
```


Count occurrences:

```bash
uniq -c sorted.txt
```

---

- **7. `tr` — Translate/Delete**

Translate lowercase to uppercase:

```bash
tr 'a-z' 'A-Z' < file.txt
```


Delete characters:

```bash
tr -d '0-9' < file.txt
```


---

- **8. `wc` — Count**

Lines:

```bash
wc -l file.txt
```

Words:

```bash
wc -w file.txt
```

Characters:

```bash
wc -c file.txt
```


---

- **9. `head` / `tail`**

First N lines:

```bash
head -n 10 file.txt
```

Last N lines:

```bash
tail -n 10 file.txt
```

Follow mode (live updates):

```bash
tail -f logfile.txt
```

---

### Task 6: Useful Patterns and One-Liners
Include at least 5 real-world one-liners you find useful. Examples:
- Find and delete files older than N days
- Count lines in all `.log` files
- Replace a string across multiple files
- Check if a service is running
- Monitor disk usage with alerts
- Parse CSV or JSON from command line
- Tail a log and filter for errors in real time

---
- **1. Find and Delete Files Older Than N Days**

Delete `.log` files older than 30 days:
```bash
find /var/log -name "*.log" -type f -mtime +30 -delete
```
- **2. Count Lines in All `.log` Files**

```bash
wc -l *.log**
```
Shows line counts for each log file.

- **3. Replace a String Across Multiple Files**

Replace "foo" with "bar" in all `.txt` files:
```bash
sed -i 's/foo/bar/g' *.txt
```


- **4. Check if a Service Is Running**

```bash
ps aux | grep -i nginx
```

Lists processes matching "nginx".

- **5. Monitor Disk Usage with Alerts**

Alert if `/` usage exceeds 90%:
```bash
df -h / | awk 'NR==2 {if ($5+0 > 90) print "Disk almost full!"}'
```


- **6. Parse CSV from Command Line**

Print 2nd column from CSV:
```bash
awk -F, '{print $2}' data.csv
```


- **7. Tail a Log and Filter for Errors in Real Time**

```bash
tail -f /var/log/app.log | grep -i "error"
```
---

### Task 7: Error Handling and Debugging
Document with examples:
1. Exit codes — `$?`, `exit 0`, `exit 1`
2. `set -e` — exit on error
3. `set -u` — treat unset variables as error
4. `set -o pipefail` — catch errors in pipes
5. `set -x` — debug mode (trace execution)
6. Trap — `trap 'cleanup' EXIT`

---

- **1. Exit Codes**

Last command exit status:
```bash
echo $?
```

Exit with success:
```bash
exit 0
```

Exit with failure:
```bash
exit 1
```


- **2. `set -e` — Exit on Error**

Stops script immediately if any command fails.
```bash
set -e
cp file1 file2   # if fails, script exits
```


- **3. `set -u` — Treat Unset Variables as Error**

Throws error when using undefined variables.
```bash
set -u
echo $UNDEFINED   # causes error
```


- **4. `set -o pipefail` — Catch Errors in Pipes**

Ensures pipeline fails if any command fails.
```bash
set -o pipefail
grep "pattern" file.txt | sort | uniq
```


- **5. `set -x` — Debug Mode**

Prints each command before execution.
```bash
set -x
echo "Debugging enabled"
```


- **6. `Trap` — Run Cleanup on Exit**

Executes a function or command when script exits.
```bash
cleanup() {
  echo "Cleaning up..."
  rm -f /tmp/tempfile
}

trap cleanup EXIT
```
---
### Task 8: Bonus — Quick Reference Table

| Topic              | Key Syntax                          | Example                                |
|--------------------|-------------------------------------|----------------------------------------|
| Variable           | `VAR="value"`                       | `NAME="DevOps"`                        |
| Argument           | `$1`, `$2`, `$#`, `$@`              | `./script.sh arg1 arg2`                |
| If                 | `if [ condition ]; then ... fi`     | `if [ -f file ]; then echo "Exists"; fi` |
| Elif / Else        | `elif [ cond ]; then ... else ...`  | `elif [ $a -eq 10 ]; then echo "Equal"` |
| For loop           | `for i in list; do ... done`        | `for i in 1 2 3; do echo $i; done`     |
| For loop (C-style) | `for ((i=0; i<5; i++))`             | `for ((i=1; i<=5; i++)); do echo $i; done` |
| While loop         | `while [ cond ]; do ... done`       | `while [ $count -le 5 ]; do echo $count; ((count++)); done` |
| Until loop         | `until [ cond ]; do ... done`       | `until [ $count -gt 5 ]; do echo $count; ((count++)); done` |
| Break / Continue   | `break`, `continue`                 | `if [ $i -eq 3 ]; then break; fi`      |
| Function           | `func() { ... }`                    | `my_func() { echo "Hi"; }`             |
| Call Function      | `func_name`                         | `my_func`                              |
| Function Args      | `$1`, `$2` inside function          | `greet() { echo "Hello $1"; }`         |
| Return Value       | `return N` / `echo value`           | `return 0` / `echo $((a+b))`           |
| Local Variable     | `local VAR=value`                   | `local msg="Scoped"`                   |
| Exit Codes         | `$?`, `exit 0`, `exit 1`            | `echo $?` / `exit 1`                   |
| set -e             | Exit on error                       | `set -e; cp file1 file2`               |
| set -u             | Error on unset vars                 | `set -u; echo $UNDEF`                  |
| set -o pipefail    | Fail if any pipe fails              | `set -o pipefail; grep "x" file \| sort` |
| set -x             | Debug mode (trace execution)        | `set -x; echo "Debugging"`             |
| trap               | `trap 'cleanup' EXIT`               | `trap 'rm -f /tmp/tmpfile' EXIT`       |
| grep               | `grep [flags] pattern file`         | `grep -i "error" logfile.txt`          |
| awk                | `awk '{print $1}' file`             | `awk -F, '{print $2}' data.csv`        |
| sed                | `sed 's/foo/bar/g' file`            | `sed -i 's/error/warn/g' logfile.txt`  |
| cut                | `cut -d, -fN file`                  | `cut -d, -f2 file.csv`                 |
| sort               | `sort [flags] file`                 | `sort -n numbers.txt`                  |
| uniq               | `uniq [flags] file`                 | `uniq -c sorted.txt`                   |
| tr                 | `tr set1 set2`                      | `tr 'a-z' 'A-Z' < file.txt`            |
| wc                 | `wc -l/-w/-c file`                  | `wc -l file.txt`                       |
| head / tail        | `head -n N file` / `tail -n N file` | `tail -f /var/log/app.log`             |
| One-liner: Delete old files | `find path -mtime +N -delete` | `find /var/log -name "*.log" -mtime +30 -delete` |
| One-liner: Count lines | `wc -l *.log`                   | `wc -l *.log`                          |
| One-liner: Replace string | `sed -i 's/foo/bar/g' *.txt` | `sed -i 's/error/warning/g' *.log`     |
| One-liner: Service check | `ps aux \| grep service`       | `ps aux \| grep nginx`                  |
| One-liner: Tail errors | `tail -f file \| grep error`     | `tail -f app.log \| grep -i error`      |

---







