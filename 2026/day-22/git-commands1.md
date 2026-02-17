# Git Command Cheat Sheet

## Setup & Config

- `git init` → Initializes a new empty Git repository in the current directory.

    *Example*: `git init` → creates `.git/` folder to start version control.

- `git config --global user.name "Your Name"` → Sets your global Git username (used to label commits).

    *Example*: `git config --global user.name "Manas Bhowmick"`

- `git config --global user.email "your.email@example.com"`- → Sets your global Git email (used to identify commits).

    *Example*: `git config --global user.email "manash1211@gmail.com"`

- `git config --list`- → Displays all current Git configuration values (global, system, and local).

    *Example*: Shows `user.name=Manas Bhowmick` and `user.email=manash1211@gmail.com`

---

## Basic Workflow

- `git add <filename>` → Stages the specified file, marking it for inclusion in the next commit.

    *Example*: `git add git-commands.md` → adds `git-commands.md` to the staging area.

- `git commit -m "Message" <filename>`→ Commits the staged file(s) with a descriptive message, creating a snapshot in history.
    
    *Example*: `git commit -m "Added definition for git add command and few minor changes in formatting" git-commands.md `


- `git branch <branch_name>` → Creates a new branch but does not switch to it.

     *Example*: `git branch feature1` → creates ``feature1` branch.


- `git checkout <branch_name>` → Switches to the specified branch.

     *Example*: `git checkout feature1` → switches to `feature1` branch


- `git checkout -b <branch_name>` → Creates a new branch and switches to it immediately.

     *Example*: `git checkout -b feature2` → creates an switches to new branch `feature-2`.

- `git switch <branch_name>` → Switches to the specified branch (modern alternative to checkout)

     *Example*: `git switch master` → Switch to master branch.


- `git branch -d <branch_name>` → Deletes the specified branch (only if it has been merged).

     *Example*: `git branch -d feature2` → Deletes `feature2` branch.


- `git remote -v` → Shows the list of remote repositories linked to your project (with URLs).

     *Example:* `git remote -v` → Displays list of remote repositories.


- `git remote add origin ssh-url` → Sets the URL of the remote named `origin` (e.g., from HTTPS to SSH).

     *Example:* `git remote add origin https://github.com/1630254/devops-git-practice.git`

- `git remote set-url origin ssh-url` → Changes the URL of the remote named `origin` (e.g., from HTTPS to SSH).

     *Example:* `git remote set-url origin git@github.com:1630254/devops-git-practice.git`

- `git fetch <branch>` → Downloads changes from the remote branch but does **not** merge them into your local branch.

     *Example:* `git fetch origin main`

- `git pull origin main` → Fetches changes from the remote `main` branch **and merges them** into your local `main`.
     
     *Example:* `git pull origin main`

- `git remote add upstream <https-url>` → Adds the original repository as a new remote called `upstream` (used to sync your fork).

     *Example:* `git remote add upstream https://github.com/TrainWithShubham/90DaysOfDevOps.git`

- `git fetch upstream` → Downloads the latest changes from the original repo (`upstream`) without merging.

      *Example:* `git fetch upstream`

- `git merge upstream/main` → Merges the changes from the original repo’s `main` branch into your local `main`.

     *Example:* `git merge upstream/master`


---

## Viewing Changes

- `git status` → Shows the current state of the working directory and staging area (tracked, untracked, staged files).

    *Example*: `git status` → might display “modified:git-commands.md”.

- `git log`→ Displays the commit history with IDs, authors, dates, and messages.

    *Example*: `git log` → shows a list of commits like commit `c8d0cc8 Added defination for git add command and few minor changes in formatting`

- `git branch` → Lists all local branches in your repository.
    
    *Example*: `git branch` → list local branches
---
