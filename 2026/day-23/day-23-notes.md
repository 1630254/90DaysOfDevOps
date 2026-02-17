# Git Branching & Working with GitHub

### Task 1: Understanding Branches
Answer these in your `day-23-notes.md`:

**1. What is a branch in Git?**

A branch in Git is essentially a pointer to a specific commit in the repository. It represents an independent line of development.  
- Think of it as a way to work on new features or bug fixes without affecting the main project.  
- Example:  
```bash
  git branch feature-login
```
This creates a new branch called `feature-login`.


**2. Why do we use branches instead of committing everything to `main`?**

Branches allow developers to isolate their work. This prevents unfinished or experimental code from disrupting the stable version in `main`.
- 	Benefits:
    - 	Safe experimentation
    - 	Easier collaboration
    - 	Cleaner history
- 	Example:

    If we’re building a new payment system, we can do it in a branch called `feature-payment`. Once it’s tested, we can merge it into `main` .

**3. What is `HEAD` in Git?**

`HEAD`is a reference to the current commit your working directory is based on.
- 	It usually points to the latest commit in your current branch.
- 	Example:
```bash
git log --oneline
```
-	The commit at the top is what `HEAD` points to.
-	If we switch branches, `HEAD` moves to point to that branch’s latest commit.


**4. What happens to your files when you switch branches?**

When we switch branches, Git updates the files in our working directory to match the snapshot of the commit that branch points to.
- Example:
```bash
git checkout feature-login
```
- If `feature-login` has different code than `main`, our files will change accordingly.
- Important: If we have uncommitted changes, Git may prevent switching to avoid overwriting our work.


---

### Task 2: Branching Commands — Hands-On
In your `devops-git-practice` repo, perform the following:
1. List all branches in your repo
```bash
git branch  
* master
```

2. Create a new branch called `feature-1`
```bash
git branch feature-1
```

3. Switch to `feature-1`
```bash
git checkout feature-1
Switched to branch 'feature-1'
```

4. Create a new branch and switch to it in a single command — call it `feature-2`
```bash
git checkout -b feature-2
Switched to a new branch 'feature-2'
```

5. Try using `git switch` to move between branches — how is it different from `git checkout`?
```bash
git switch feature-1
Switched to branch 'feature-1'
```

**git switch vs git checkout**

| Command                | Purpose                                           | Example                        | Notes                                                                 |
|------------------------|---------------------------------------------------|--------------------------------|-----------------------------------------------------------------------|
| `git checkout`         | Multi-purpose: switch branches **and** restore files | `git checkout my-branch`       | Powerful but overloaded — can be confusing because it does two jobs.  |
| `git switch`           | Introduced in Git 2.23 to **only** handle branch switching | `git switch my-branch`         | Easier to understand, safer, and beginner-friendly.                   |
| `git checkout -b new`  | Create and switch to a new branch                  | `git checkout -b feature-login`| Old way of creating + switching.                                      |
| `git switch -c new`    | Create and switch to a new branch                  | `git switch -c feature-login`  | Modern, clearer alternative to `checkout -b`.                         |


6. Make a commit on `feature-1` that does **not** exist on `main`
```bash
git branch
* feature-1
  feature-2
  master

vim git-commands.md 

cat git-commands.md 

- **Setup & Config**
`git init` → Initializes a new empty Git repository in the current directory.
*Example*: `git init` → creates `.git/` folder to start version control.

`git config --global user.name "Your Name"` → Sets your global Git username (used to label commits).
*Example*: `git config --global user.name "Manas Bhowmick"`

`git config --global user.email "your.email@example.com"`- → Sets your global Git email (used to identify commits).
*Example*: `git config --global user.email "manash1211@gmail.com"`

`git config --list`- → Displays all current Git configuration values (global, system, and local).
*Example*: Shows `user.name=Manas Bhowmick` and `user.email=manash1211@gmail.com`


- **Basic Workflow**
`git add <filename>` → Stages the specified file, marking it for inclusion in the next commit.
*Example*: `git add git-commands.md` → adds `git-commands.md` to the staging area.

`git commit -m "Message" <filename>`→ Commits the staged file(s) with a descriptive message, creating a snapshot in history.
*Example*: `git commit -m "Added definition for git add command and few minor changes in formatting" git-commands.md `




- **Viewing Changes**
`git status` → Shows the current state of the working directory and staging area (tracked, untracked, staged files).
*Example*: `git status` → might display “modified:git-commands.md”.

`git log`→ Displays the commit history with IDs, authors, dates, and messages.
*Example*: `git log` → shows a list of commits like commit `c8d0cc8 Added defination for git add command and few minor changes in formatting`

This is a test...
```
```bash
git status
On branch feature-1
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   git-commands.md

no changes added to commit (use "git add" and/or "git commit -a")

git add .

git commit -m "chore: minor testing for feature-1" git-commands.md 
[feature-1 1bf390c] chore: minor testing for feature-1
 1 file changed, 1 insertion(+), 1 deletion(-)

git status
On branch feature-1
nothing to commit, working tree clean
```

7. Switch back to `main` — verify that the commit from `feature-1` is not there
```bash
git switch master
Switched to branch 'master'

cat git-commands.md 

- **Setup & Config**
`git init` → Initializes a new empty Git repository in the current directory.
*Example*: `git init` → creates `.git/` folder to start version control.

`git config --global user.name "Your Name"` → Sets your global Git username (used to label commits).
*Example*: `git config --global user.name "Manas Bhowmick"`

`git config --global user.email "your.email@example.com"`- → Sets your global Git email (used to identify commits).
*Example*: `git config --global user.email "manash1211@gmail.com"`

`git config --list`- → Displays all current Git configuration values (global, system, and local).
*Example*: Shows `user.name=Manas Bhowmick` and `user.email=manash1211@gmail.com`


- **Basic Workflow**
`git add <filename>` → Stages the specified file, marking it for inclusion in the next commit.
*Example*: `git add git-commands.md` → adds `git-commands.md` to the staging area.

`git commit -m "Message" <filename>`→ Commits the staged file(s) with a descriptive message, creating a snapshot in history.
*Example*: `git commit -m "Added definition for git add command and few minor changes in formatting" git-commands.md `




- **Viewing Changes**
`git status` → Shows the current state of the working directory and staging area (tracked, untracked, staged files).
*Example*: `git status` → might display “modified:git-commands.md”.

`git log`→ Displays the commit history with IDs, authors, dates, and messages.
*Example*: `git log` → shows a list of commits like commit `c8d0cc8 Added defination for git add command and few minor changes in formatting`

```
8. Delete a branch you no longer need
```bash
git branch
  feature-1
  feature-2
* master

git branch -d feature-2
Deleted branch feature-2 (was ddf5a9a).

git branch
  feature-1
* master
```
9. Add all branching commands to your `git-commands.md`

---

### Task 3: Push to GitHub
1. Create a **new repository** on GitHub (do NOT initialize it with a README)
2. Connect your local `devops-git-practice` repo to the GitHub remote
```bash
git remote add origin https://github.com/1630254/devops-git-practice.git

git remote -v                                                           
origin	https://github.com/1630254/devops-git-practice.git (fetch)
origin	https://github.com/1630254/devops-git-practice.git (push)
```
3. Push your `main` branch to GitHub

```bash
git push origin master
Username for 'https://github.com':
```
> to make this repo. passwordless we have used public ssh certificate and set origin with ssh-url.  

```bash
git remote -v                                                                          
origin	https://github.com/1630254/devops-git-practice.git (fetch)
origin	https://github.com/1630254/devops-git-practice.git (push)


git remote set-url origin git@github.com:1630254/devops-git-practice.git

git remote -v                                                           
origin	git@github.com:1630254/devops-git-practice.git (fetch)
origin	git@github.com:1630254/devops-git-practice.git (push)
```
```bash
git push origin master
The authenticity of host 'github.com (20.207.73.82)' can't be established.
ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'github.com' (ED25519) to the list of known hosts.
Enumerating objects: 15, done.
Counting objects: 100% (15/15), done.
Delta compression using up to 4 threads
Compressing objects: 100% (10/10), done.
Writing objects: 100% (15/15), 2.19 KiB | 373.00 KiB/s, done.
Total 15 (delta 3), reused 0 (delta 0), pack-reused 0 (from 0)
remote: Resolving deltas: 100% (3/3), done.
To github.com:1630254/devops-git-practice.git
 * [new branch]      master -> master

```

4. Push `feature-1` branch to GitHub
```bash
it push origin feature-1
Enumerating objects: 5, done.
Counting objects: 100% (5/5), done.
Delta compression using up to 4 threads
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 315 bytes | 105.00 KiB/s, done.
Total 3 (delta 1), reused 0 (delta 0), pack-reused 0 (from 0)
remote: Resolving deltas: 100% (1/1), completed with 1 local object.
remote: 
remote: Create a pull request for 'feature-1' on GitHub by visiting:
remote:      https://github.com/1630254/devops-git-practice/pull/new/feature-1
remote: 
To github.com:1630254/devops-git-practice.git
 * [new branch]      feature-1 -> feature-1

```
5. Verify both branches are visible on GitHub

6. Answer in your notes: What is the difference between `origin` and `upstream`?

| Remote Name | Typical Meaning | When It’s Used | Example Command |
|-------------|-----------------|----------------|-----------------|
| **origin**  | The default remote created when we clone a repository. It usually points to *our own fork or copy* of the repo. | Used for pushing and pulling changes to/from our personal fork. | `git push origin main` |
| **upstream**| A remote pointing to the *original repository* we forked from. | Used to fetch updates from the source project so we can keep our fork in sync. | `git fetch upstream` |

*Quick Summary:*
- `origin`	 → our fork (our copy of the repo).
- `upstream` → the original repo you forked from.
This distinction is especially useful when contributing to open-source projects, since we’ll push changes to `origin` but fetch updates from `upstream`

---

### Task 4: Pull from GitHub
1. Make a change to a file **directly on GitHub** (use the GitHub editor)
2. Pull that change to your local repo
```bash
git switch feature-1
Switched to branch 'feature-1'
```
```bash
git pull origin feature-1
From github.com:1630254/devops-git-practice
 * branch            feature-1  -> FETCH_HEAD
Updating 1bf390c..17fbb82
Fast-forward
 git-commands.md | 1 -
 1 file changed, 1 deletion(-)
```
```bash
cat git-commands.md 

- **Setup & Config**
`git init` → Initializes a new empty Git repository in the current directory.
*Example*: `git init` → creates `.git/` folder to start version control.

`git config --global user.name "Your Name"` → Sets your global Git username (used to label commits).
*Example*: `git config --global user.name "Manas Bhowmick"`

`git config --global user.email "your.email@example.com"`- → Sets your global Git email (used to identify commits).
*Example*: `git config --global user.email "manash1211@gmail.com"`

`git config --list`- → Displays all current Git configuration values (global, system, and local).
*Example*: Shows `user.name=Manas Bhowmick` and `user.email=manash1211@gmail.com`


- **Basic Workflow**
`git add <filename>` → Stages the specified file, marking it for inclusion in the next commit.
*Example*: `git add git-commands.md` → adds `git-commands.md` to the staging area.

`git commit -m "Message" <filename>`→ Commits the staged file(s) with a descriptive message, creating a snapshot in history.
*Example*: `git commit -m "Added definition for git add command and few minor changes in formatting" git-commands.md `




- **Viewing Changes**
`git status` → Shows the current state of the working directory and staging area (tracked, untracked, staged files).
*Example*: `git status` → might display “modified:git-commands.md”.

`git log`→ Displays the commit history with IDs, authors, dates, and messages.
*Example*: `git log` → shows a list of commits like commit `c8d0cc8 Added defination for git add command and few minor changes in formatting`
```

3. Answer in your notes: What is the difference between `git fetch` and `git pull`?


| Command      | What It Does | Effect on Local Branch | Example |
|--------------|--------------|------------------------|---------|
| **git fetch** | Downloads commits, branches, and files from the remote repository into your local repository. | Does **not** change your working directory or current branch. Updates only the remote-tracking branches (e.g., `origin/main`). | `git fetch origin` |
| **git pull**  | Fetches changes from the remote repository **and immediately merges** them into your current branch. | Updates your working directory and current branch with remote changes. Equivalent to `git fetch` + `git merge`. | `git pull origin main` |

*Quick Summary:*
- `git fetch` → Safe way to see what’s new on the remote before merging.
- `git pull`  → Directly brings remote changes into our current branch (can cause merge conflicts if not reviewed first)

---

### Task 5: Clone vs Fork
1. **Clone** any public repository from GitHub to your local machine
```bash
git clone https://github.com/TrainWithShubham/python-for-devops.git
Cloning into 'python-for-devops'...
remote: Enumerating objects: 145, done.
remote: Counting objects: 100% (56/56), done.
remote: Compressing objects: 100% (47/47), done.
remote: Total 145 (delta 19), reused 9 (delta 9), pack-reused 89 (from 1)
Receiving objects: 100% (145/145), 39.72 KiB | 9.93 MiB/s, done.
Resolving deltas: 100% (28/28), done.
```
```bash
ls -al python-for-devops/
total 68
drwxrwxr-x 14 ubuntu ubuntu 4096 Feb 16 23:34 .
drwxr-x---  5 ubuntu ubuntu 4096 Feb 16 23:34 ..
drwxrwxr-x  8 ubuntu ubuntu 4096 Feb 16 23:34 .git
-rw-rw-r--  1 ubuntu ubuntu   79 Feb 16 23:34 .gitignore
-rw-rw-r--  1 ubuntu ubuntu 2478 Feb 16 23:34 README.md
drwxrwxr-x  3 ubuntu ubuntu 4096 Feb 16 23:34 day-01
drwxrwxr-x  3 ubuntu ubuntu 4096 Feb 16 23:34 day-02
drwxrwxr-x  2 ubuntu ubuntu 4096 Feb 16 23:34 day-03
drwxrwxr-x  2 ubuntu ubuntu 4096 Feb 16 23:34 day-04
drwxrwxr-x  2 ubuntu ubuntu 4096 Feb 16 23:34 day-05
drwxrwxr-x  2 ubuntu ubuntu 4096 Feb 16 23:34 day-06
drwxrwxr-x  2 ubuntu ubuntu 4096 Feb 16 23:34 day-07
drwxrwxr-x  4 ubuntu ubuntu 4096 Feb 16 23:34 day-08
drwxrwxr-x  2 ubuntu ubuntu 4096 Feb 16 23:34 day-09
drwxrwxr-x  2 ubuntu ubuntu 4096 Feb 16 23:34 day-10
drwxrwxr-x  4 ubuntu ubuntu 4096 Feb 16 23:34 projects
-rw-rw-r--  1 ubuntu ubuntu  398 Feb 16 23:34 requirements.txt
```
2. **Fork** the same repository on GitHub, then clone your fork
```bash
git clone https://github.com/manas9231656456-hue/90DaysOfDevOps.git
Cloning into '90DaysOfDevOps'...
remote: Enumerating objects: 3166, done.
remote: Counting objects: 100% (14/14), done.
remote: Compressing objects: 100% (11/11), done.
remote: Total 3166 (delta 7), reused 3 (delta 3), pack-reused 3152 (from 2)
Receiving objects: 100% (3166/3166), 9.21 MiB | 37.14 MiB/s, done.
Resolving deltas: 100% (1366/1366), done.
```
```bash
ls -al 90DaysOfDevOps/
total 92
drwxrwxr-x  9 ubuntu ubuntu  4096 Feb 16 23:42 .
drwxr-x---  6 ubuntu ubuntu  4096 Feb 16 23:42 ..
drwxrwxr-x  8 ubuntu ubuntu  4096 Feb 16 23:42 .git
drwxrwxr-x  3 ubuntu ubuntu  4096 Feb 16 23:42 .github
-rw-rw-r--  1 ubuntu ubuntu   296 Feb 16 23:42 .gitignore
drwxrwxr-x 92 ubuntu ubuntu  4096 Feb 16 23:42 2023
drwxrwxr-x 92 ubuntu ubuntu  4096 Feb 16 23:42 2024
drwxrwxr-x 14 ubuntu ubuntu  4096 Feb 16 23:42 2025
drwxrwxr-x 25 ubuntu ubuntu  4096 Feb 16 23:42 2026
-rw-rw-r--  1 ubuntu ubuntu   541 Feb 16 23:42 CONTRIBUTING.md
-rw-rw-r--  1 ubuntu ubuntu  1073 Feb 16 23:42 LICENSE
-rw-rw-r--  1 ubuntu ubuntu 20849 Feb 16 23:42 LICENSE.md
-rw-rw-r--  1 ubuntu ubuntu  3053 Feb 16 23:42 README.md
-rw-rw-r--  1 ubuntu ubuntu 12779 Feb 16 23:42 TOC.md
drwxrwxr-x  2 ubuntu ubuntu  4096 Feb 16 23:42 scripts
```
3. Answer in your notes:
   - What is the difference between clone and fork?
   
   **Clone** → Copy a repository from GitHub (or any remote) to your own computer.  
  Example:  
  ```bash
  git clone https://github.com/original-owner/project.git
  ```
  👉 You now have a local copy to work on.	
    
    **Fork** → Make your own copy of someone else’s repository on GitHub itself (online).
👉 It’s like saying: “I want my own version of this project on my GitHub account.”


   - When would you clone vs fork?
   - After forking, how do you keep your fork in sync with the original repo?

---