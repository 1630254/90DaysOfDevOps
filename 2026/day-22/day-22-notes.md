

### Task 1: Install and Configure Git
1. Verify Git is installed on your machine
```bash
rpm -q git
git-2.49.0-1.fc40.x86_64
```

2. Set up your Git identity — name and email
```bash
 git config --global user.name "Manas Bhowmick"
 git config --global user.email "manash1211@gmail.com"
```

3. Verify your configuration
```bash
git config --list

user.name=Manas Bhowmick
user.email=manash1211@gmail.com
core.repositoryformatversion=0
core.filemode=true
core.bare=false
core.logallrefupdates=true
remote.origin.url=https://github.com/1630254/90DaysOfDevOps.git
remote.origin.fetch=+refs/heads/*:refs/remotes/origin/*
branch.master.remote=origin
branch.master.merge=refs/heads/master
branch.master.vscode-merge-base=origin/master
pull.rebase=false
```

---

### Task 2: Create Your Git Project
1. Create a new folder called `devops-git-practice`
```bash
mkdir devops-git-practice
```
2. Initialize it as a Git repository
```bash
cd devops-git-practice 
git init
hint: Using 'master' as the name for the initial branch. This default branch name
hint: is subject to change. To configure the initial branch name to use in all
hint: of your new repositories, which will suppress this warning, call:
hint:
hint: 	git config --global init.defaultBranch <name>
hint:
hint: Names commonly chosen instead of 'master' are 'main', 'trunk' and
hint: 'development'. The just-created branch can be renamed via this command:
hint:
hint: 	git branch -m <name>
Initialized empty Git repository in /home/student/devops-git-practice/.git/
```
3. Check the status — read and understand what Git is telling you
```bash
git status
On branch master

No commits yet

nothing to commit (create/copy files and use "git add" to track)

```

• 	We’re currently on the master branch (the default branch after ).

• 	The repository is empty — no commits have been made yet.

• 	Git is waiting for us to add files with


4. Explore the hidden `.git/` directory — look at what's inside
```bash
ls -al .git 
total 12
drwxr-xr-x. 1 student student  82 Feb 14 20:15 .
drwxr-xr-x. 1 student student   8 Feb 14 20:11 ..
-rw-r--r--. 1 student student  92 Feb 14 20:11 config
-rw-r--r--. 1 student student  73 Feb 14 20:11 description
-rw-r--r--. 1 student student  23 Feb 14 20:11 HEAD
drwxr-xr-x. 1 student student 556 Feb 14 20:11 hooks
drwxr-xr-x. 1 student student  14 Feb 14 20:11 info
drwxr-xr-x. 1 student student  16 Feb 14 20:11 objects
drwxr-xr-x. 1 student student  18 Feb 14 20:11 refs
```

---

### Task 3: Create Your Git Commands Reference
1. Create a file called `git-commands.md` inside the repo
```bash
touch git-commands.md
```
2. Add the Git commands you've used so far, organized by category:
   - **Setup & Config**
   - **Basic Workflow**
   - **Viewing Changes**
3. For each command, write:
   - What it does (1 line)
   - An example of how to use it
```   
- **Setup & Config**
`git init` -
`git config --global user.name "Your Name"`
`git config --global user.email "your.email@example.com"`
`git config --list`
- **Basic Workflow**
- **Viewing Changes**
```
---

### Task 4: Stage and Commit
1. Stage your file
```bash
git status
On branch master

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	git-commands.md

nothing added to commit but untracked files present (use "git add" to track)
```
```bash
 git add git-commands.md 
```

2. Check what's staged
```bash
git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
	new file:   git-commands.md

```
3. Commit with a meaningful message
```bash
git commit -m "First commit for git-commands.md"
[master (root-commit) 0bbf0be] First commit for git-commands.md
 1 file changed, 8 insertions(+)
 create mode 100644 git-commands.md
```
4. View your commit history
```bash
git log
commit 0bbf0be760a0854ffaa97cefb2855629826c489e (HEAD -> master)
Author: Manas Bhowmick <manash1211@gmail.com>
Date:   Sat Feb 14 20:35:02 2026 +0530

    First commit for git-commands.md
```
---

### Task 5: Make More Changes and Build History
1. Edit `git-commands.md` — add more commands as you discover them
```

- **Setup & Config**
`git init` → Initializes a new empty Git repository in the current directory.
*Example*: git init → creates .git/ folder to start version control.

`git config --global user.name "Your Name"` → Sets your global Git username (used to label commits).
*Example*: git config --global user.name "Manas Bhowmick"

`git config --global user.email "your.email@example.com"`- → Sets your global Git email (used to identify commits).
*Example*: git config --global user.email "manash1211@gmail.com"

`git config --list`- → Displays all current Git configuration values (global, system, and local).
*Example*: Shows user.name=Manash Roy and user.email=manash.roy@example.com


- **Basic Workflow**
`git add <filename>`
`git commit -m "Message" <filename>`


- **Viewing Changes**
`git status`
`git log`
```
2. Check what changed since your last commit
```bash
git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   git-commands.md

no changes added to commit (use "git add" and/or "git commit -a")
```
3. Stage and commit again with a different, descriptive message
```bash
git add git-commands.md 
git commit -m "Added defination for Setup commands and added new commands for workflow and viewing changes"
[master 74a4ae5] Added defination for Setup commands and added new commands for workflow and viewing changes
 1 file changed, 20 insertions(+), 5 deletions(-)
```
4. Repeat this process at least **3 times** so you have multiple commits in your history
```bash
git add git-commands.md 
git commit -m "Added defination for git add command and few minor changes in formatting" git-commands.md 
[master c8d0cc8] Added defination for git add command and few minor changes in formatting
 1 file changed, 9 insertions(+), 6 deletions(-)
```
```bash
git add git-commands.md 
git commit -m "Added definition for git add command" git-commands.md 
[master 734a3b0] Added definition for git add command
 1 file changed, 4 insertions(+), 1 deletion(-)
```
```bash
git add git-commands.md 
[student@fedora]~/devops-git-practice% git commit -m "Added definition for git status and git log command"
[master ddf5a9a] Added definition for git status and git log command
 1 file changed, 6 insertions(+), 2 deletions(-)
```
5. View the full history in a compact format
```bash
git log --oneline
ddf5a9a (HEAD -> master) Added definition for git status and git log command
734a3b0 Added definition for git add command
c8d0cc8 Added defination for git add command and few minor changes in formatting
74a4ae5 Added defination for Setup commands and added new commands for workflow and viewing changes
0bbf0be First commit for git-commands.md
```

---

### Task 6: Understand the Git Workflow
Answer these questions in your own words (add them to a `day-22-notes.md` file):
1. What is the difference between `git add` and `git commit`?
- **`git add`** → Moves file changes into the **staging area** (like marking files to be saved).
- **`git commit`** → Actually saves those staged changes into the **repository history** with a message.

👉 Think of `git add` as *“prepare to save”* and `git commit` as *“save with a note.”*

2. What does the **staging area** do? Why doesn't Git just commit directly?
- The **staging area** is a middle step where we collect and review changes before saving them.
- Git doesn’t commit directly because we may want to:
  - Choose only certain files to commit.
  - Double‑check what’s going in.
  - Group related changes together.

👉 It’s like packing your bag before a trip — you decide what to take before leaving.


3. What information does `git log` show you?
- Shows the **history of commits** in the repository.
- Each entry includes:
  - Commit ID (unique hash)
  - Author name and email
  - Date and time
  - Commit message

👉 It’s like a diary of everything saved in Git.


4. What is the `.git/` folder and what happens if you delete it?
- The `.git/` folder is where Git stores all the **repository data** (commits, branches, configs).
- If we delete it:
  - Our project files remain, but Git forgets all history.
  - The folder becomes just a normal directory with no version control.

👉 It’s like removing Git’s brain — files stay, but Git won’t remember anything.


5. What is the difference between a **working directory**, **staging area**, and **repository**?
- **Working directory** → Where we edit files (your actual project folder).
- **Staging area** → Where we prepare selected changes before saving.
- **Repository** → Where Git permanently stores commits and history.

👉 Simple analogy:
- **Working directory** = kitchen (where we cook).
- **Staging area** = plate (where we arrange food).
- **Repository** = fridge (where we store meals for later).
---
