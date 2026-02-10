# Shell Scripting Basics

### Task 1: Your First Script
1. Create a file `hello.sh`
2. Add the shebang line `#!/bin/bash` at the top
3. Print `Hello, DevOps!` using `echo`
4. Make it executable and run it
```bash
#!/bin/bash

echo "Hello, DevOps!"
```
```bash
chmod +x hello.sh
```
```bash
./hello.sh
Hello, DevOps!
```

**Document:** What happens if you remove the shebang line?

Doesn't impacts my scripts execution. But below are expected behaviour.
- With shebang → Always clear and predictable about the shell while exceuting the script.
- Without shebang → depends on how we invoke the script and what /bin/sh points to. Safe only if we always run with an explicit interpreter.


---

### Task 2: Variables
1. Create `variables.sh` with:
   - A variable for your `NAME`
   - A variable for your `ROLE` (e.g., "DevOps Engineer")
   - Print: `Hello, I am <NAME> and I am a <ROLE>`

```bash
#!/bin/bash

NAME="Manas Bhowmick"
ROLE="DevOps Engineer"

echo "Hello, I am $NAME and I am a $ROLE"
```
```bash
chmod +x variables.sh
```
```bash
./variables.sh
Hello, I am Manas Bhowmick and I am a DevOps Engineer
```
2. Try using single quotes vs double quotes — what's the difference?

- `Double quotes` allows variables or commands inside to be evaluated.
- `Single quotes` used when we want the text exactly as written.


---

### Task 3: User Input with read
1. Create `greet.sh` that:
   - Asks the user for their name using `read`
   - Asks for their favourite tool
   - Prints: `Hello <name>, your favourite tool is <tool>`

```bash
#!/bin/bash

read -p "What is your Name..? " NAME
read -p "What is your favourite Tool..? " TOOL

echo "Hello $NAME, your favourite tool is $TOOL"

```
```bash
chmod +x greet.sh
```

```bash
./greet.sh  
What is your Name..? Manas
What is your favourite Tool..? Jenkins
Hello Manas, your favourite tool is Jenkins
```
---

### Task 4: If-Else Conditions
1. Create `check_number.sh` that:
   - Takes a number using `read`
   - Prints whether it is **positive**, **negative**, or **zero**

```bash
#!/bin/bash

read -p "Please input a number: " NUMBER

if [[ $NUMBER -eq 0 ]]
then
        echo "Number is zero"
elif [[ $NUMBER -gt 0 ]]
then
        echo "Number is greater than zero.."

elif [[ $NUMBER -lt 0 ]]
then
        echo "Number is less than zero.."
fi
```
```bash
chmod +x check_number.sh
```
```bash
./check_number.sh
Please input a number: 2
Number is greater than zero..
./check_number.sh
Please input a number: 0
Number is zero
./check_number.sh
Please input a number: -2
Number is less than zero..

```
2. Create `file_check.sh` that:
   - Asks for a filename
   - Checks if the file **exists** using `-f`
   - Prints appropriate message
```bash
!/bin/bash
read -p "Enter the full path name for the file to check: " FILE

if [[ -f $FILE ]]
then
        echo "File $FILE: exists"
else
        echo "File $FILE: Error Not Found!!"

fi
```
```bash
chmod +x file_check.sh
```
```bash
./file_check.sh
Enter the full path name for the file to check: /etc/passwd
File /etc/passwd: exists
./file_check.sh
Enter the full path name for the file to check: /etc/host
File /etc/host: Error Not Found!!

```

---

### Task 5: Combine It All
Create `server_check.sh` that:
1. Stores a service name in a variable (e.g., `nginx`, `sshd`)
2. Asks the user: "Do you want to check the status? (y/n)"
3. If `y` — runs `systemctl status <service>` and prints whether it's **active** or **not**
4. If `n` — prints "Skipped."
```bash
#!/bin/bash

read -p "Enter the service name to check .." SERVICE

read -p "Do you want to check the status? (y/n)" ANSWER

ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')

if [[ "$ANSWER" == "y" ]]
then
        STATUS=`systemctl status $SERVICE | grep Active | awk '{print $2, $3}'`
        echo $STATUS

elif [[ $ANSWER == "n" ]]
then
        echo "Skipped"
else
        echo "Enter a valid response"
fi
```
```bash
chmod +x server_check.sh
```
```bash
./server_check.sh
Enter the service name to check ..nginx
Do you want to check the status? (y/n)y
active (running)
./server_check.sh
Enter the service name to check ..nginx
Do you want to check the status? (y/n)n
Skipped
./server_check.sh
Enter the service name to check ..nginx
Do you want to check the status? (y/n)abc
Enter a valid response
./server_check.sh
Enter the service name to check ..docker
Do you want to check the status? (y/n)y
inactive (dead)
```
---
## What I learned

1. **Script Basics & Shebang Importance**  
   - Start scripts with `#!/bin/bash` for predictable execution.  
   - Without a shebang, behavior depends on how the script is invoked and the system’s default shell.  

2. **Working with Variables & User Input**  
   - Use variables (`NAME`, `ROLE`) to store values and print them with `echo`.  
   - Double quotes expand variables, while single quotes print text literally.  
   - `read` enables interactive input, making scripts dynamic and user‑friendly.  

3. **Conditional Logic & Service Checks**  
   - `if‑else` statements handle numeric comparisons and file existence checks.  
   - Combine variables, user input, and conditions to build practical scripts like `server_check.sh` for monitoring service status.  

---