# File Permissions & File Operations

## Files Created

- devops.txt
- notes.txt
- script.sh


## Permission Changes

Before:
- Permissions for all the files are same i.e. 664

After:
- `devop.txt` → read-only → 444
- `notes.txt` → 640
- `script.sh` → 775

## Commands Used

### Task 1: Create Files

1. Create empty file `devops.txt` using `touch`
``` bash
touch devops.txt
```
2. Create `notes.txt` with some content using `cat` or `echo`
```bash
cat > notes.txt
Hello from Line -1               

echo "Hello from Echo" >> notes.txt 
```
3. Create `script.sh` using `vim` with content: `echo "Hello DevOps"`
```bash
vim script.sh
```

**Verify:** `ls -l` to see permissions
```bash
ls -l 
total 8
-rw-rw-r-- 1 ubuntu ubuntu  0 Feb  5 01:48 devops.txt
-rw-rw-r-- 1 ubuntu ubuntu 36 Feb  5 01:49 notes.txt
-rw-rw-r-- 1 ubuntu ubuntu 22 Feb  5 01:50 script.sh
```

### Task 2: Read Files

1. Read `notes.txt` using `cat`
```bash
cat notes.txt 
Hello from Line -1 
Hello from Echo
```
2. View `script.sh` in vim read-only mode
```bash
vim script.sh 
```
3. Display first 5 lines of `/etc/passwd` using `head`
```bash
head -n 5 /etc/passwd
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
```
4. Display last 5 lines of `/etc/passwd` using `tail`
```bash
tail -n 5 /etc/passwd
ubuntu:x:1000:1000:Ubuntu:/home/ubuntu:/bin/bash
tokyo:x:1001:1001::/home/tokyo:/bin/sh
berlin:x:1002:1002::/home/berlin:/bin/sh
professor:x:1003:1003::/home/professor:/bin/sh
nairobi:x:1004:1006::/home/nairobi:/bin/sh
```

### Task 3: Understand Permissions 

Format: `rwxrwxrwx` (owner-group-others)
- `r` = read (4), `w` = write (2), `x` = execute (1)

Check your files: `ls -l devops.txt notes.txt script.sh`

What are current permissions? Who can read/write/execute?

```bash
ls -l 
total 8
-rw-rw-r-- 1 ubuntu ubuntu  0 Feb  5 01:48 devops.txt
-rw-rw-r-- 1 ubuntu ubuntu 36 Feb  5 01:49 notes.txt
-rw-rw-r-- 1 ubuntu ubuntu 22 Feb  5 01:50 script.sh
```
- devops.txt → `owner`= rw (6), `group`= rw (6), `other`= r (4)

Answer: Permissions for all the files are same i.e. 664.
- `Ownwer` & `Group` only have read/write permission, no permissions for `other`.


### Task 4: Modify Permissions

1. Make `script.sh` executable → run it with `./script.sh`
```bash
chmod +x script.sh 
ls -l script.sh 
-rwxrwxr-x 1 ubuntu ubuntu 22 Feb  5 01:50 script.sh
./script.sh 
Hello DevOPS..
```

2. Set `devops.txt` to read-only (remove write for all)
```bash
chmod -w devops.txt
ls -l devops.txt 
-r--r--r-- 1 ubuntu ubuntu 0 Feb  5 01:48 devops.txt
```

3. Set `notes.txt` to `640` (owner: rw, group: r, others: none)
```bash
chmod 640 notes.txt
ls -l notes.txt 
-rw-r----- 1 ubuntu ubuntu 36 Feb  5 01:49 notes.txt
```

4. Create directory `project/` with permissions `755`
```bash
mkdir project
chmod 755 project/
ls -ld project/
drwxr-xr-x 2 ubuntu ubuntu 4096 Feb  5 02:15 project/
```

**Verify:** `ls -l` after each change

### Task 5: Test Permissions

1. Try writing to a read-only file - what happens?
```bash
echo "Writing data with echo" > devops.txt 
-bash: devops.txt: Permission denied
```
2. Try executing a file without execute permission
```bash
/devops.txt
-bash: ./devops.txt: Permission denied
```
3. Document the error messages

## What I Learned
**1. File Creation and Content Management**
- We learned how to create files using different commands:
    - `touch` → creates an empty file.
    - `cat` or `echo` → adds content to a file.
    - `vim` → creates and edits files interactively.
- Verification with  shows file size and ownership, confirming successful creation.

  **Key takeaway:** Different commands serve different purposes for file creation and editing, and  helps verify file existence and details.

**2. Reading Files and System Exploration**
- Commands like `cat`,`head`, and `tail` allow you to read files in different ways:
    - `cat` → displays full content.
    - `head`→ shows the first few lines.
    - `tail`→ shows the last few lines.
- We also explored `/etc/passwd` , which stores user account information.

  **Key takeaway:** File reading commands are powerful for inspecting both user-created files and system configuration files.

**3. Understanding and Modifying Permissions**
- Permissions follow the `rwxrwxrwx` format (owner-group-others).
- You practiced modifying permissions with `chmod`:
    - Adding execute (`+x`) to run scripts.
    - Removing write (`-w`) to make files read-only.
    - Setting numeric modes like `640` for fine-grained control.
- Testing showed how permission changes directly affect what actions are allowed (e.g., denied write or execute).

  **Key takeaway:** Permissions are central to Linux security and collaboration—knowing how to read and modify them ensures proper control over files and directories
---