# Shell Scripting: Functions & Slightly Advanced Concepts

### Task 1: Basic Functions
1. Create `functions.sh` with:
   - A function `greet` that takes a name as argument and prints `Hello, <name>!`
   - A function `add` that takes two numbers and prints their sum
   - Call both functions from the script

```bash
#!/bin/bash

#Function to greet  
funcGreet () {
	name=$1
	echo "Hello, $name...!!"
}

# Function to add two numbers
funcAdd () {
	num1=$1
	num2=$2
	result=$((num1 + num2))
	echo "Sum of two numbers are: $result"
}

#Calling functions
funcGreet Manas 
funcAdd 4 6
```
```bash
chmod +x function.sh
```
```bash
./function.sh
Hello, Manas...!!
Sum of two numbers are: 10
```
---

### Task 2: Functions with Return Values
1. Create `disk_check.sh` with:
   - A function `check_disk` that checks disk usage of `/` using `df -h`
   - A function `check_memory` that checks free memory using `free -h`
   - A main section that calls both and prints the results

```bash
#!/bin/bash

# Function to check available disk space
check_disk() {
    AVAILABLE_SPACE=$(df -h | awk 'NR==2 {print $4}')
    echo "$AVAILABLE_SPACE"
}

# Function to check available memory
check_memory() {
    AVAILABLE_MEMORY=$(free -h | awk 'NR==2 {print $7}')
    echo "$AVAILABLE_MEMORY"
}

# Calling functions
FREE_SPACE=$(check_disk)
echo "Available Space in / partition is: $FREE_SPACE"

FREE_MEMORY=$(check_memory)
echo "Available Free Memory is: $FREE_MEMORY"
```
```bash
chmod +x disk_check.sh
```
```bash
./disk_check.sh 
Available Space in / partition is: 24G
Available Free Memory is: 1.2Gi
```

---

### Task 3: Strict Mode — `set -euo pipefail`
1. Create `strict_demo.sh` with `set -euo pipefail` at the top
2. Try using an **undefined variable** — what happens with `set -u`?
3. Try a command that **fails** — what happens with `set -e`?
4. Try a **piped command** where one part fails — what happens with `set -o pipefail`?

**Document:** What does each flag do?
- `set -e` →
- `set -u` →
- `set -o pipefail` →

```bash
#!/bin/bash
set -euo pipefail

# 1. Undefined variable test (set -u)
echo "Trying to use an undefined variable..."
echo "$UNDEFINED_VAR"   # This will cause the script to exit immediately

# 2. Command failure test (set -e)
echo "Trying a failing command..."
ls /var/tmp/test   # This will cause the script to exit immediately

# 3. Pipe failure test (set -o pipefail)
echo "Trying a failing pipe..."
false | grep something      # With pipefail, the script exits because 'false' fails
```
```bash
chmod +x strict_demo.sh
```
```bash
./strict_demo.sh 
Trying to use an undefined variable...
./strict_demo.sh: line 6: UNDEFINED_VAR: unbound variable
 UNDEFINED_VAR=123
 export UNDEFINED_VAR
./strict_demo.sh    
Trying to use an undefined variable...
123
Trying a failing command...
ls: cannot access '/var/tmp/test': No such file or directory
mkdir -p /var/tmp/test
./strict_demo.sh      
Trying to use an undefined variable...
123
Trying a failing command...
Trying a failing pipe...
```

What does each flag do?
- `set -e` → **Exit on error**
If any command returns a non-zero exit status, the script stops immediately.
    - **Example:**  will terminate the script.
- `set -u` 	→ **Treat unset variables as errors**
Using an undefined variable causes the script to exit.
    - **Example:**  will throw an error and stop execution.
- `set -o pipefail` → **Fail on any command in a pipeline**
Normally, only the last command in a pipeline determines success/failure. With 
`pipefail`, if any command fails, the whole pipeline fails.
    - **Example:** `false | grep something` will exit because `false` fails, even though `grep` runs.
---

### Task 4: Local Variables
1. Create `local_demo.sh` with:
   - A function that uses `local` keyword for variables
   - Show that `local` variables don't leak outside the function
   - Compare with a function that uses regular variables

```bash
#!/bin/bash

# Function with local variable
local_demo() {
    local var="Local variable"
    echo "Inside local_demo: $var"
}

# Function with global variable
global_demo() {
    var="Global variable"
    echo "Inside global_demo: $var"
}

echo "=== Local Demo ==="
local_demo
echo "Outside after local_demo: ${var:-var is undefined}"

echo
echo "=== Global Demo ==="
global_demo
echo "Outside after global_demo: $var"
```
```bash
chmod +x local_demo.sh
```
```bash
=== Local Demo ===
Inside local_demo: Local variable
Outside after local_demo: var is undefined

=== Global Demo ===
Inside global_demo: Global variable
Outside after global_demo: Global variable
```
---

### Task 5: Build a Script — System Info Reporter
Create `system_info.sh` that uses functions for everything:
1. A function to print **hostname and OS info**
2. A function to print **uptime**
3. A function to print **disk usage** (top 5 by size)
4. A function to print **memory usage**
5. A function to print **top 5 CPU-consuming processes**
6. A `main` function that calls all of the above with section headers
7. Use `set -euo pipefail` at the top

```bash
#!/bin/bash
set -euo pipefail

# Function to print hostname and OS info
print_system_info() {
    echo "===== System Info ====="
    echo "Hostname: $(hostname)"
    echo "OS Info:"
    uname -a
    echo
}

# Function to print uptime
print_uptime() {
    echo "===== Uptime ====="
    uptime
    echo
}

# Function to print disk usage (top 5 by size)
print_disk_usage() {
    echo "===== Disk Usage (Top 5) ====="
    df -h | sort -k2 -h -r | head -n 5
    echo
}

# Function to print memory usage
print_memory_usage() {
    echo "===== Memory Usage ====="
    free -h
    echo
}

# Function to print top 5 CPU-consuming processes
print_top_cpu_processes() {
    echo "===== Top 5 CPU-consuming Processes ====="
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
    echo
}

# Main function to call all others
main() {
    print_system_info
    print_uptime
    print_disk_usage
    print_memory_usage
    print_top_cpu_processes
}

# Run main
main
```
```bash
chmod +x system_info.sh
```
```bash
===== System Info =====
Hostname: fedora
OS Info:
Linux fedora 6.14.5-100.fc40.x86_64 #1 SMP PREEMPT_DYNAMIC Fri May  2 14:22:13 UTC 2025 x86_64 GNU/Linux

===== Uptime =====
 07:36:57 up 4 days, 12:06,  3 users,  load average: 0.95, 0.67, 0.51

===== Disk Usage (Top 5) =====
/dev/sda3        39G   16G   24G  40% /home
/dev/sda3        39G   16G   24G  40% /
tmpfs           3.9G   82M  3.8G   3% /dev/shm
tmpfs           3.9G  4.3M  3.9G   1% /tmp
tmpfs           1.6G  2.0M  1.6G   1% /run

===== Memory Usage =====
               total        used        free      shared  buff/cache   available
Mem:           7.7Gi       6.5Gi       265Mi       142Mi       1.4Gi       1.2Gi
Swap:          7.7Gi       4.5Gi       3.2Gi

===== Top 5 CPU-consuming Processes =====
    PID COMMAND         %CPU
   1983 gnome-shell     22.8
   3805 firefox         10.2
 238571 Isolated Web Co  4.9
 178792 code             4.4
 221663 Isolated Web Co  1.8

```
Output should look clean and readable.

---

## What I learned

1. **Functions for Modularity**  
   - Creating functions like `greet` and `add` helps organize code into reusable blocks.  
   - Functions can take arguments and perform operations, making scripts cleaner and easier to maintain.

2. **Strict Mode for Safety**  
   - Using `set -euo pipefail` ensures scripts fail fast and safely:
     - `-e`: exit on any command error.  
     - `-u`: treat unset variables as errors.  
     - `-o pipefail`: fail if any command in a pipeline fails.  
   - This prevents silent failures and makes scripts more robust.

3. **Variable Scope Control**  
   - The `local` keyword confines variables to a function, preventing accidental overwrites in the global scope.  
   - Without `local`, variables leak outside functions, which can cause unintended side effects.  
   - Using `local` improves reliability and predictability in larger scripts.

---