# Shell Scripting: Loops, Arguments & Error Handling

### Task 1: For Loop
1. Create `for_loop.sh` that:
   - Loops through a list of 5 fruits and prints each one
```bash
#!/bin/bash

fruits=("apple" "banana" "coconut" "mango" "orange")

for fruit in ${fruits[@]}
do
        echo $fruit
done
```
```bash
chmod +x for_loop.sh
```
```bash
./for_loop.sh
apple
banana
coconut
mango
orange
```

2. Create `count.sh` that:
   - Prints numbers 1 to 10 using a for loop
```bash
#!/bin/bash
for i in {1..10}
do
        echo $i
done       
```
```bash
chmod +x count.sh
```
```bash
./count.sh
1
2
3
4
5
6
7
8
9
10
```
---

### Task 2: While Loop
1. Create `countdown.sh` that:
   - Takes a number from the user
   - Counts down to 0 using a while loop
   - Prints "Done!" at the end
```bash
#!/bin/bash

read -p "Input a number..: " NUM

while [ $NUM -gt 0 ]
do
       echo $NUM
       NUM=$((NUM-1))
done
echo "Done..!!"
```
```bash
chmod +x countdown.sh
```
```bash
./countdown.sh  
Input a number..: 5
5
4
3
2
1
Done..!!
```

---

### Task 3: Command-Line Arguments
1. Create `greet.sh` that:
   - Accepts a name as `$1`
   - Prints `Hello, <name>!`
   - If no argument is passed, prints "
```bash
#!/bin/bash

if [[ $# -eq 0 ]]
then
        echo "Usage: $0 <name>"
        exit 1
fi

NAME=$1
echo "Hello $1..!!"
```
```bash
chmod +x greet.sh
```
```bash
/greet.sh      
Usage: ./greet.sh <name>
./greet.sh Manas
Hello Manas..!!

```

2. Create `args_demo.sh` that:
   - Prints total number of arguments (`$#`)
   - Prints all arguments (`$@`)
   - Prints the script name (`$0`)

```bash
#!/bin/bash
if [[ $# -eq 0 ]]
then
        ARGS="No Arguments Provided"
else
        ARGS=$@
fi

echo "Total number of arguments: $#"
echo "Script Name: $0"
echo "Arguments: $ARGS"
```
```bash
chmod +x greet.sh
```
```bash
./args_demo.sh                         
Total number of arguments: 0
Script Name: ./args_demo.sh
Arguments: No Arguments Provided
[student@fedora]~/90DaysOfDevOps/2026/day-17% ./args_demo.sh "apple" "banana" "mango"
Total number of arguments: 3
Script Name: ./args_demo.sh
Arguments: apple banana mango
```
---

### Task 4: Install Packages via Script
1. Create `install_packages.sh` that:
   - Defines a list of packages: `nginx`, `curl`, `wget`
   - Loops through the list
   - Checks if each package is installed (use `dpkg -s` or `rpm -q`)
   - Installs it if missing, skips if already present
   - Prints status for each package
```bash
#!/bin/bash

packages=("nginx" "curl" "wget")

for package in ${packages[@]}
do
        echo "Checking for: $package.."
        sleep 1
        rpm -q $package 2>&1 > /dev/null
        STATUS=`echo $?`
        if [[ $STATUS -eq 0 ]]
        then
                echo "$package is already installed.. Skipping..!!"
        else
                echo "Installing $package.."
                dnf install $package -y
        fi

done
```
```bash
chmod +x install_packages.sh
```
```bash
./install_packages.sh
Checking for: nginx..
nginx is already installed.. Skipping..!!
Checking for: curl..
curl is already installed.. Skipping..!!
Checking for: wget..
Installing wget..
```

> Run as root: `sudo -i` or `sudo su`

---

### Task 5: Error Handling
1. Create `safe_script.sh` that:
   - Uses `set -e` at the top (exit on error)
   - Tries to create a directory `/tmp/devops-test`
   - Tries to navigate into it
   - Creates a file inside
   - Uses `||` operator to print an error if any step fails

Example:
```bash
mkdir /tmp/devops-test || echo "Directory already exists"
```
```bash
#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status


mkdir /tmp/devops-test > /dev/null 2>&1 || echo "Error: Could not create directory (maybe it already exists)"
cd /tmp/devops-test || echo "Error: Could not navigate into directory"
touch testfile.txt || echo "Error: Could not create file"

echo "Script executed successfully!"
```
```bash
chmod +x safe_script.sh
```
```bash
./safe_script.sh   
Script executed successfully!
./safe_script.sh
Error: Could not create directory (maybe it already exists)
Script executed successfully!
```
2. Modify your `install_packages.sh` to check if the script is being run as root — exit with a message if not.

```bash
#!/bin/bash

# Checking for root priviledge
ID=$(id -u $(whoami))
if [[ $ID != 0 ]]
then
        echo "WARNING!! This script requires root priviledge.."
        exit 1
fi

# Defining list for the packages to be installed
packages=("nginx" "curl" "wget")

#Iterating throup the list
for package in ${packages[@]}
do
        echo "Checking for: $package.."
        sleep 1
        rpm -q $package 2>&1 > /dev/null # Checking for installed packages
        STATUS=`echo $?` # Checking for exit status
        if [[ $STATUS -eq 0 ]] # Decision making based on exit status
        then
                echo "$package is already installed.. Skipping..!!"
        else
                echo "Installing $package.."
                dnf install $package -y
        fi

done
```

```bash
./install_packages.sh
WARNING!! This script requires root priviledge..

```
---

## What I learned

**1. Control Flow with Loops**
-	For loops let us iterate over lists (like fruits or numbers) easily.
**Example:** `for fruit in ${fruits[@]}` cycles through each element in an array.
- 	While loops are useful when we don’t know the exact number of iterations in advance, but want to continue until a condition is met (like counting down until a number reaches 0).
**Learning:** Choose the right loop depending on whether we’re iterating over a fixed list or running until a condition changes.

**2. Command-Line Arguments & Script Flexibility**
- 	`$0`,`$1` ,`$@` , and `$#` give us access to the script name, first argument, all arguments, and argument count.
- 	Adding argument checks (if [[ $# - eq 0 ]]) makes scripts more user-friendly and prevents errors.
**Learning:** Command-line arguments make scripts reusable and dynamic, so you don’t hardcode values.

**3. Error Handling & Safety**
-	`set -e` ensures the script exits immediately on error, preventing partial or inconsistent execution.
- 	Using `||` allows you to print custom error messages when a command fails.
-	Checking for root privileges (`id -u`) before installing packages prevents permission errors.
**Learning:** Always anticipate failures and handle them gracefully — this makes scripts safer, more professional, and easier to debug.
---