
### Task 1: Self-Assessment Checklist
Go through the checklist below. For each item, mark yourself honestly:
- **Can do confidently**
- **Need to revisit**
- **Haven't done yet**

#### Linux
-  ✅ Navigate the file system, create/move/delete files and directories
-  ✅ Manage processes — list, kill, background/foreground
-  ✅ Work with systemd — start, stop, enable, check status of services
-  ✅ Read and edit text files using vi/vim or nano
-  ✅ Troubleshoot CPU, memory, and disk issues using top, free, df, du
-  ✅ Explain the Linux file system hierarchy (/, /etc, /var, /home, /tmp, etc.)
-  ✅ Create users and groups, manage passwords
-  ✅ Set file permissions using chmod (numeric and symbolic)
-  ✅ Change file ownership with chown and chgrp
-  ✅ Create and manage LVM volumes
-  ✅ Check network connectivity — ping, curl, netstat, ss, dig, nslookup
-  ✅ Explain DNS resolution, IP addressing, subnets, and common ports

#### Shell Scripting
-  ✅ Write a script with variables, arguments, and user input
-  ✅ Use if/elif/else and case statements
-  ✅ Write for, while, and until loops
-  🔄 Define and call functions with arguments and return values
-  🔄 Use grep, awk, sed, sort, uniq for text processing
-  🔄 Handle errors with set -e, set -u, set -o pipefail, trap
-  ✅ Schedule scripts with crontab

#### Git & GitHub
-  ✅ Initialize a repo, stage, commit, and view history
-  ✅ Create and switch branches
-  ✅ Push to and pull from GitHub
-  ✅ Explain clone vs fork
-  ✅ Merge branches — understand fast-forward vs merge commit
-  ✅ Rebase a branch and explain when to use it vs merge
-  ✅ Use git stash and git stash pop
-  ✅ Cherry-pick a commit from another branch
-  ✅ Explain squash merge vs regular merge
-  ✅ Use git reset (soft, mixed, hard) and git revert
-  🔄 Explain GitFlow, GitHub Flow, and Trunk-Based Development
-  🔄 Use GitHub CLI to create repos, PRs, and issues

---

### Task 2: Revisit Your Weak Spots
1. Pick **3 topics** from the checklist where you marked "Need to revisit"
2. Go back to that day's challenge and redo the hands-on tasks
3. Document what you re-learned in `day-28-notes.md`

---

### Task 3: Quick-Fire Questions
Answer these from memory (no Googling). Then verify your answers:

1. What does `chmod 755 script.sh` do?
- Sets file permissions:
  - Owner: **read, write, execute**
  - Group: **read, execute**
  - Others: **read, execute**
- Example:
  ```bash
  chmod 755 script.sh
  ./script.sh   # now executable by all users
  ```
2. What is the difference between a process and a service?
- Process: Any running program instance.
    -   Example: `firefox` when we open the browser.
-   Service: A background process managed by `systemed`.
    -   Example: `ssh` (SSH daemon).
    -   Check with:
    ```bash
    systemctl status sshd
    ```
3. How do you find which process is using port 8080?
    ```bash
    sudo lsof -i :8080
    sudo ss -ltnp | grep 8080
    ```
- Output shows PID and program name.

4. What does `set -euo pipefail` do in a shell script?
- `e` : exit on error.
- `-u` : error on unset variables.
- `-o pipefail`: pipeline fails if any command fails.
- 	Example:
    ```bash
        set -euo pipefail
        cat missingfile.txt | grep foo   # script exits immediately
    ```
5. What is the difference between `git reset --hard` and `git revert`?

-  `git reset --hard`: moves branch pointer, discards changes permanently.
    ```bash
    git reset --hard HEAD~1   # delete last commit
    ```
-  `git revert`: creates a new commit that undoes changes.
    ```bash
    git revert HEAD           # safe in shared repos
    ```
6. What branching strategy would you recommend for a team of 5 developers shipping weekly?
- Recommended: GitHub Flow / Trunk‑based development
    - Developers branch off main.
    - Open PRs → merge quickly.
    - Weekly release tags from main.
- Example:
    ```bash
    git checkout -b feature/login
    git push origin feature/login
    ```
7. What does `git stash` do and when would you use it?
- Temporarily saves uncommitted changes.
- Example:
    ```bash
    git stash          # save changes
    git checkout main  # switch branch safely
    git stash pop      # restore changes
    ```
8. How do you schedule a script to run every day at 3 AM?
- Edit cron jobs:
    ```bash
    crontab -e
    ```
- Add:
    ```bash
    0 3 * * * /path/to/script.sh
    ```
9. What is the difference between `git fetch` and `git pull`?
- `git fetch`: downloads commits/branches, no merge.
    ```bash
    git fetch origin
    ```
- `git pull`: fetch + merge (or rebase).
    ```bash
    git pull origin main
    ```

10. What is LVM and why would you use it instead of regular partitions?

- 	**LVM (Logical Volume Manager):** abstraction over physical disks.
- 	Benefits:
    - 	Resize volumes dynamically.
    - 	Create snapshots.
    -   Combine multiple disks.
- 	Example:
    ```bash
    lvcreate -L 10G -n myvolume myvg
    lvextend -L +5G /dev/myvg/myvolume
    ```
---
---

### Task 4: Organize Your Work
1. Make sure all your daily submissions (day-1 through day-27) are committed and pushed
2. Check that your `git-commands.md` is up to date
3. Check that your shell scripting cheat sheet is complete
4. Verify your GitHub profile and repos are clean (from Day 27)

    **All activities pertaining to Task‑4 have been successfully completed and are thoroughly organized as outlined.**
---

### Task 5: Teach It Back
Pick **one topic** you've learned and write a short explanation (5-10 lines) as if you're teaching it to someone who has never heard of it. Add it to your `day-28-notes.md`.

Examples:
- Explain Git branching to a non-developer

    Git branching creates a safe copy of our project so we can experiment without breaking the main version. The main branch holds the official version we all trust. When we create a branch, we work in our own sandbox — we add features, fix issues, or try new ideas. Once we finish our changes, we merge them back into the main branch. If our experiment fails, we delete the branch and keep the main project clean. This approach lets us work on different tasks at the same time without interfering with each other.
    
- Explain file permissions to a new Linux user
- Explain what a crontab is and why sysadmins use it

Teaching is the best test of understanding.

---

