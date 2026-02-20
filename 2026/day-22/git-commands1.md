# Git Command Cheat Sheet

## Setup & Config

- `git init` → **Initializes** a new empty Git repository in the current directory.

    *Example*: `git init` → creates `.git/` folder to start version control.

- `git config --global user.name "Your Name"` → Sets our global **Git username** (used to label commits).

    *Example*: `git config --global user.name "Manas Bhowmick"`

- `git config --global user.email "your.email@example.com"` → Sets our global **Git email** (used to identify commits).

    *Example*: `git config --global user.email "manash1211@gmail.com"`

- `git config --list` → Displays all current **Git configuration values** (global, system, and local).

    *Example*: Shows `user.name=Manas Bhowmick` and `user.email=manash1211@gmail.com`

## Basic Workflow (add, commit, status, log, diff)

- `git add <filename>` → **Stages the specified file**, marking it for inclusion in the next commit.

    *Example*: `git add git-commands.md` → adds `git-commands.md` to the staging area.

- `git commit -m "Message" <filename>`→ **Commits the staged file(s)** with a descriptive message, creating a snapshot in history.
    
    *Example*: `git commit -m "Added definition for git add command and few minor changes in formatting" git-commands.md `

- `git log --oneline` → shows a **compact history of commits**, each in one line.
    
    *Example:* `877e568 Update README with project setup`

- `git status` →  Shows the **current state** of the working directory and staging area (e.g., which files are modified, staged, or untracked). 

   *Example:* `git status` → "modified: index.html, untracked: style.css"

- `git diff` →  Displays the **differences between files** in our working directory and the staging area (or between commits).

   *Example:* `git diff` → Shows line-by-line changes, such as `-color: red;` replaced with `+color: blue;`


## Branching (branch, checkout, switch)

- `git branch <branch_name>` → **Creates** a new branch but does not switch to it.

     *Example*: `git branch feature-1` → creates `feature-1` branch.


- `git checkout <branch_name>` → **Switches** to the specified branch.

     *Example*: `git checkout feature-1` → switches to `feature-1` branch


- `git checkout -b <branch_name>` → **Creates** a new branch and **switches** to it immediately.

     *Example*: `git checkout -b feature-2` → creates an switches to new branch `feature-2`.

- `git switch <branch_name>` → **Switches** to the specified branch (modern alternative to checkout)

     *Example*: `git switch master` → Switch to master branch.

- `git branch -d <branch_name>` → **Deletes** the specified branch (only if it has been merged).

     *Example*: `git branch -d feature-2` → Deletes `feature-2` branch.


## Remote (push, pull, fetch, clone, fork)

- `git remote -v` → Shows the **list of remote repositories** linked to your project (with URLs).

     *Example:* `git remote -v` → Displays list of remote repositories.

- `git remote add origin ssh-url` → **Sets the URL** of the remote named `origin` (e.g., from HTTPS to SSH).

     *Example:* `git remote add origin https://github.com/1630254/devops-git-practice.git`

- `git remote set-url origin ssh-url` → **Changes the URL** of the remote named `origin` (e.g., from HTTPS to SSH).

     *Example:* `git remote set-url origin git@github.com:1630254/devops-git-practice.git`

- `git fetch <branch>` → **Downloads** changes from the remote branch but does **not** merge them into your local branch.

     *Example:* `git fetch origin main`

- `git pull origin main` → **Fetches** changes from the remote `main` branch and **merges** them into your local `main`.
     
     *Example:* `git pull origin main`

- `git remote add upstream <https-url>` → **Adds** the **original** repository as a new remote called `upstream` (used to sync your fork).

     *Example:* `git remote add upstream https://github.com/TrainWithShubham/90DaysOfDevOps.git`

- `git fetch upstream` → **Downloads** the latest changes from the **original** repo (`upstream`) without merging.

     *Example:* `git fetch upstream`

- `git clone https://github.com/TrainWithShubham/python-for-devops.git`

- `git merge upstream/main` → **Merges** the changes from the **original** repo’s `main` branch into your local `main`.

     *Example:* `git merge upstream/master`


## Merging & Rebasing

- `git merge --squash <branch>` → One **consolidated** change instead of multiple commits.

    *Example:* `git merge --squash feature-profile` → Combines all commits from `feature-profile` into a single staged commit.

- `git merge <branch>` → Keeps all **individual** commits intact

    *Example:* `git merge feature-settings` → Merges the full commit history from `feature-settings` into the current branch.

- `git rebase <branch>` → **Rewrites history** so our work appears after the latest branch commits

    *Example:* `git rebase master` → Reapplies current branch’s commits on top of `master`

## Stash & Cherry Pick

- `git stash` → **Temporarily saves** our uncommitted changes and clears the working directory

    *Example:* `git stash` - "Saved working directory and index state WIP"

- `git stash pop` → **Restores** the most **recent stash** and removes it from the stash list

    *Example:* `git stash pop` → "reapplies saved changes"

- `git stash list` → Shows all **stashed changes** with identifiers

    *Example:* `stash@{0}: On feature-login: New update Login-2`

- `git stash apply <stash_id>` → **Reapplies** a specific stash by its ID **without removing** it from the list 

    *Example:* `git stash apply stash@{0}` → Reapplies a `stash@{0}` by its ID without removing from list.

- `git cherry-pick <commit_hash>` → **Applies** the changes from a **specific commit** onto current branch.

    *Example:* `git cherry-pick e792f4a` → Applies `e792f4a` from a specific commit onto current branch.

## Reset & Revert

- `git reset --soft HEAD~1` →  Moves HEAD back one commit, keeping changes **staged**. 

   *Example:* `git reset --soft HEAD~1` → Changes from the last commit remain staged, ready to recommit.

- `git reset --mixed HEAD~1` →  Moves HEAD back one commit, keeping changes in the **working directory but unstaged** (default behavior).  

   *Example:* `git reset --mixed HEAD~1` → Changes from the last commit are kept but need to be re‑added before committing.

- `git reset --hard HEAD~1` →  Moves HEAD back one commit and **discards all changes** from staging and working directory (destructive).  

   *Example:* `git reset --hard HEAD~1` → Last commit and its changes are completely removed.

- `git revert <commit_hash>` →  Creates a new commit that **undoes the changes** of the specified commit while preserving history.  
  
   *Example:* `git revert a1b2c3d` → Adds a new commit that reverses the changes introduced by commit `a1b2c3d`.

---