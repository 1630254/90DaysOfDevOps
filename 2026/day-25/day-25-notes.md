# Git Reset vs Revert & Branching Strategies

### Task 1: Git Reset — Hands-On
1. Make 3 commits in your practice repo (commit A, B, C)
```bash
git checkout -b feature-reset
Switched to a new branch 'feature-reset'

touch test-fileA

echo "Hello test-A" >> test-fileA 

git add .

git commit -m "Commit-A done" test-fileA 
[feature-reset 07b8534] Commit-A done
 1 file changed, 1 insertion(+)
 create mode 100644 test-fileA
```
```bash
touch test-fileB

echo "Hello test-B" >> test-fileB      

git add .                               

git commit -m "Commit-B done" test-fileB
[feature-reset a5e907f] Commit-B done
 1 file changed, 1 insertion(+)
 create mode 100644 test-fileB
```
```bash
touch test-fileC

echo "Hello test-C" >> test-fileC  

git add .       

git commit -m "Commit-C done" test-fileC
[feature-reset 664d1c1] Commit-C done
 1 file changed, 1 insertion(+)
 create mode 100644 test-fileC
```
```bash
git log --oneline
664d1c1 (HEAD -> feature-reset) Commit-C done
a5e907f Commit-B done
07b8534 Commit-A done
c723214 (master) Hotfix: Correct API endpoint. Conflict resolved.
523dba5 feat:Some changes made in index.html
8c9748f (feature-settings) chore:Improve settings UI
e03ba39 chore:Implement settings validation
f98b49b feat: Add settings page
97d74ee feat:Add profile feature (squashed)
bd4ecbc Update README with dashboard info
5c926db Merge branch 'feature-login'
f82ddfd chore: Modified login message in feature-login
69dd67f chore: Minor update to Login message
dc34325 Merge branch 'feature-signup'
877e568 Update README with project setup
7638ef7 (feature-signup) Implement signup validation
fb1c676 Add signup page
4c582c0 Implement login validation
f8f26ef feat:Add login page
54647af feat:Added index.html
b786bdd chore: updated few more commands
17fbb82 (origin/feature-1, feature-1) Remove test line from git-commands.md
1bf390c chore: minor testing for feature-1
ddf5a9a (origin/master) Added definition for git status and git log command
734a3b0 Added definition for git add command
c8d0cc8 Added defination for git add command and few minor changes in formatting
74a4ae5 Added defination for Setup commands and added new commands for workflow and viewing changes
0bbf0be First commit for git-commands.md
```
2. Use `git reset --soft` to go back one commit — what happens to the changes?
```bash
git status             
On branch feature-reset
nothing to commit, working tree clean

git reset --soft HEAD~1

git status
On branch feature-reset
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new file:   test-fileC
```
```bash
git log --oneline
a5e907f (HEAD -> feature-reset) Commit-B done
07b8534 Commit-A done
c723214 (master) Hotfix: Correct API endpoint. Conflict resolved.
523dba5 feat:Some changes made in index.html
8c9748f (feature-settings) chore:Improve settings UI
e03ba39 chore:Implement settings validation
f98b49b feat: Add settings page
97d74ee feat:Add profile feature (squashed)
bd4ecbc Update README with dashboard info
5c926db Merge branch 'feature-login'
f82ddfd chore: Modified login message in feature-login
69dd67f chore: Minor update to Login message
dc34325 Merge branch 'feature-signup'
877e568 Update README with project setup
7638ef7 (feature-signup) Implement signup validation
fb1c676 Add signup page
4c582c0 Implement login validation
f8f26ef feat:Add login page
54647af feat:Added index.html
b786bdd chore: updated few more commands
17fbb82 (origin/feature-1, feature-1) Remove test line from git-commands.md
1bf390c chore: minor testing for feature-1
ddf5a9a (origin/master) Added definition for git status and git log command
734a3b0 Added definition for git add command
c8d0cc8 Added defination for git add command and few minor changes in formatting
74a4ae5 Added defination for Setup commands and added new commands for workflow and viewing changes
0bbf0be First commit for git-commands.md
```
```bash
git commit -m "Commit-C done" test-fileC
[feature-reset 052f959] Commit-C done
 1 file changed, 1 insertion(+)
 create mode 100644 test-fileC
```

3. Re-commit, then use `git reset --mixed` to go back one commit — what happens now?
```bash
git reset --mixed HEAD~1                

git status
On branch feature-reset
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	test-fileC

nothing added to commit but untracked files present (use "git add" to track)
```
```bash
git log --oneline                       
a5e907f (HEAD -> feature-reset) Commit-B done
07b8534 Commit-A done
c723214 (master) Hotfix: Correct API endpoint. Conflict resolved.
523dba5 feat:Some changes made in index.html
8c9748f (feature-settings) chore:Improve settings UI
e03ba39 chore:Implement settings validation
f98b49b feat: Add settings page
97d74ee feat:Add profile feature (squashed)
bd4ecbc Update README with dashboard info
5c926db Merge branch 'feature-login'
f82ddfd chore: Modified login message in feature-login
69dd67f chore: Minor update to Login message
dc34325 Merge branch 'feature-signup'
877e568 Update README with project setup
7638ef7 (feature-signup) Implement signup validation
fb1c676 Add signup page
4c582c0 Implement login validation
f8f26ef feat:Add login page
54647af feat:Added index.html
b786bdd chore: updated few more commands
17fbb82 (origin/feature-1, feature-1) Remove test line from git-commands.md
1bf390c chore: minor testing for feature-1
ddf5a9a (origin/master) Added definition for git status and git log command
734a3b0 Added definition for git add command
c8d0cc8 Added defination for git add command and few minor changes in formatting
74a4ae5 Added defination for Setup commands and added new commands for workflow and viewing changes
0bbf0be First commit for git-commands.md
```
```bash
git add .                               

git commit -m "Commit-C done" test-fileC
[feature-reset 099fd30] Commit-C done
 1 file changed, 1 insertion(+)
 create mode 100644 test-fileC

git status
On branch feature-reset
nothing to commit, working tree clean
```
4. Re-commit, then use `git reset --hard` to go back one commit — what happens this time?
```bash
git reset --hard HEAD~1                 
HEAD is now at a5e907f Commit-B done
```
```bash
ls -l test*
-rw-r--r--. 1 student student 13 Feb 19 07:20 test-fileA
-rw-r--r--. 1 student student 13 Feb 19 07:22 test-fileB

git status
On branch feature-reset
nothing to commit, working tree clean

git log --oneline                       
a5e907f (HEAD -> feature-reset) Commit-B done
07b8534 Commit-A done
c723214 (master) Hotfix: Correct API endpoint. Conflict resolved.
523dba5 feat:Some changes made in index.html
8c9748f (feature-settings) chore:Improve settings UI
e03ba39 chore:Implement settings validation
f98b49b feat: Add settings page
97d74ee feat:Add profile feature (squashed)
bd4ecbc Update README with dashboard info
5c926db Merge branch 'feature-login'
f82ddfd chore: Modified login message in feature-login
69dd67f chore: Minor update to Login message
dc34325 Merge branch 'feature-signup'
877e568 Update README with project setup
7638ef7 (feature-signup) Implement signup validation
fb1c676 Add signup page
4c582c0 Implement login validation
f8f26ef feat:Add login page
54647af feat:Added index.html
b786bdd chore: updated few more commands
17fbb82 (origin/feature-1, feature-1) Remove test line from git-commands.md
1bf390c chore: minor testing for feature-1
ddf5a9a (origin/master) Added definition for git status and git log command
734a3b0 Added definition for git add command
c8d0cc8 Added defination for git add command and few minor changes in formatting
74a4ae5 Added defination for Setup commands and added new commands for workflow and viewing changes
0bbf0be First commit for git-commands.md
```
5. Answer in your notes:
   - What is the difference between `--soft`, `--mixed`, and `--hard`?


| Reset Mode | Effect on Commit History | Effect on Staging Area (Index) | Effect on Working Directory | Typical Use Case |
|------------|---------------------------|--------------------------------|-----------------------------|------------------|
| `--soft`   | Moves HEAD back, commits removed from history | Changes remain **staged** | Working directory unchanged | Re-do commit message or combine commits while keeping changes staged |
| `--mixed`  | Moves HEAD back, commits removed from history | Changes become **unstaged** | Working directory unchanged | Re-do commit but review/edit changes before staging again |
| `--hard`   | Moves HEAD back, commits removed from history | Changes **discarded** | Working directory **discarded** | Completely throw away unwanted commits and changes |

   - Which one is destructive and why?

   `--hard` is destructive because it erases changes from both staging and working directory. Once gone, we cannot recover them unless we had backups or reflog


   - When would you use each one?

   **Soft** → When we want to redo the last commit but keep changes staged (e.g., amend commit message).

   **Mixed** → When we want to redo the last commit but review/edit changes before recommitting.

   **Hard** → When you want to completely discard unwanted commits and changes (cleanup/reset state).

   - Should you ever use `git reset` on commits that are already pushed?

   **Generally, no.**

   Reset rewrites history, which causes problems for collaborators who already pulled the old commits.

   Instead, use `git revert` for shared/public history (it creates a new commit that undoes changes safely).

   `git reset` is fine for local/private branches where we control the history.


---
### Task 2: Git Revert — Hands-On
1. Make 3 commits (commit X, Y, Z)
```bash
git checkout -b feature-revert
Switched to a new branch 'feature-revert'
[student@fedora]~/devops-git-practice% touch revert-file1
[student@fedora]~/devops-git-practice% mv revert-file1 revert-fileX         
[student@fedora]~/devops-git-practice% echo "Revert file X" >> revert-fileX 
[student@fedora]~/devops-git-practice% git add .
[student@fedora]~/devops-git-practice% git commit -m "Added revert-file X " revert-fileX 
[feature-revert 32e5ad1] Added revert-file X
 1 file changed, 1 insertion(+)
 create mode 100644 revert-fileX
```
```bash
touch revert-fileY          
[student@fedora]~/devops-git-practice% echo "Revert file Y" >> revert-fileY            
[student@fedora]~/devops-git-practice% git add .                                        
[student@fedora]~/devops-git-practice% git commit -m "Added revert-file Y " revert-fileY
[feature-revert 4d45f0b] Added revert-file Y
 1 file changed, 1 insertion(+)
 create mode 100644 revert-fileY
```
```bash
touch revert-fileZ                  
[student@fedora]~/devops-git-practice% echo "Revert file Z" >> revert-fileZ            
[student@fedora]~/devops-git-practice% git add .                                        
[student@fedora]~/devops-git-practice% git commit -m "Added revert-file Z" revert-fileZ 
[feature-revert ae931be] Added revert-file Z
 1 file changed, 1 insertion(+)
 create mode 100644 revert-fileZ
```
```bash
git log --oneline
ae931be (HEAD -> feature-revert) Added revert-file Z
4d45f0b Added revert-file Y
32e5ad1 Added revert-file X
c7d11ab (feature-login) chore:New update for feature Login-2
550af2a chore: added minor feature-1
eae4d0f chore:added some feature-01
f82ddfd chore: Modified login message in feature-login
4c582c0 Implement login validation
f8f26ef feat:Add login page
54647af feat:Added index.html
b786bdd chore: updated few more commands
17fbb82 (origin/feature-1, feature-1) Remove test line from git-commands.md
1bf390c chore: minor testing for feature-1
ddf5a9a (origin/master) Added definition for git status and git log command
734a3b0 Added definition for git add command
c8d0cc8 Added defination for git add command and few minor changes in formatting
74a4ae5 Added defination for Setup commands and added new commands for workflow and viewing changes
0bbf0be First commit for git-commands.md
```

2. Revert commit Y (the middle one) — what happens?
```bash
git revert 4d45f0b
[feature-revert b16c585] Revert "Added revert-file Y"
 1 file changed, 1 deletion(-)
 delete mode 100644 revert-fileY
```
3. Check `git log` — is commit Y still in the history?
```bash
git log --oneline
b16c585 (HEAD -> feature-revert) Revert "Added revert-file Y"
ae931be Added revert-file Z
4d45f0b Added revert-file Y
32e5ad1 Added revert-file X
c7d11ab (feature-login) chore:New update for feature Login-2
550af2a chore: added minor feature-1
eae4d0f chore:added some feature-01
f82ddfd chore: Modified login message in feature-login
4c582c0 Implement login validation
f8f26ef feat:Add login page
54647af feat:Added index.html
b786bdd chore: updated few more commands
17fbb82 (origin/feature-1, feature-1) Remove test line from git-commands.md
1bf390c chore: minor testing for feature-1
ddf5a9a (origin/master) Added definition for git status and git log command
734a3b0 Added definition for git add command
c8d0cc8 Added defination for git add command and few minor changes in formatting
74a4ae5 Added defination for Setup commands and added new commands for workflow and viewing changes
0bbf0be First commit for git-commands.md

```
4. Answer in your notes:
   - How is `git revert` different from `git reset`?

 Command      | What it does | Effect on History | Effect on Changes |
|--------------|--------------|-------------------|-------------------|
| `git reset`  | Moves HEAD backwards | Rewrites history (commits removed from branch) | Changes may be staged, unstaged, or discarded depending on mode |
| `git revert` | Creates a new commit that undoes a previous commit | Preserves history (no commits removed) | Changes are reversed safely in a new commit |


   - Why is revert considered **safer** than reset for shared branches?

  `Revert` doesn’t rewrite history — it adds a new commit.
  
  This means collaborators don’t face conflicts or broken history when they pull.

  `Reset` rewrites commit history, which can cause divergence and force others to reconcile mismatched histories.

   - When would you use revert vs reset?

   `Revert` → Use on shared/public branches when you need to undo a commit but keep history intact.
    
   `Reset` → Use on local/private branches when you want to rewrite history, clean up commits, or discard changes before pushing.

---
### Task 3: Reset vs Revert — Summary
Create a comparison in your notes:

| Aspect              | `git reset`                                   | `git revert`                                |
|---------------------|-----------------------------------------------|---------------------------------------------|
| Effect on History   | Rewrites history (commits removed from branch) | Preserves history (adds a new commit)       |
| What Happens        | Moves HEAD backwards; commits may be staged, unstaged, or discarded depending on mode | Creates a new commit that undoes a previous commit |
| Visibility in Log   | Removed commits no longer appear in branch history (though recoverable via reflog) | Original commit remains visible; new "revert" commit is added |
| Safety              | Risky on shared branches (causes divergence)  | Safe on shared branches (no history rewrite) |
| Typical Use Case    | Local/private branches for cleanup, rewriting, or discarding changes | Shared/public branches to safely undo a commit |
| Destructive?        | Can be destructive (`--hard` discards changes permanently) | Non-destructive (changes undone but history preserved) |

---
### Task 4: Branching Strategies
Research the following branching strategies and document each in your notes with:
- How it works (short description)
- A simple diagram or flow (text-based is fine)
- When/where it's used
- Pros and cons

1. **GitFlow** — develop, feature, release, hotfix branches
2. **GitHub Flow** — simple, single main branch + feature branches
3. **Trunk-Based Development** — everyone commits to main, short-lived branches

### 1. GitFlow
**How it works:**  
- Multiple long-lived branches:  
  - `main` (production-ready code)  
  - `develop` (integration branch)  
  - `feature/*` (new features)  
  - `release/*` (preparing a release)  
  - `hotfix/*` (urgent fixes to production)  

    **Diagram (text-based):**
    ```bash
    main ────●─────────────●─────────────●─────────────
          \            ↑             ↑
           \           |             |
            \→ hotfix  |             |
    develop ────●───●───●──┘─────●───────┘
             \   \
              \   → feature branches
               \
                → release branches

    ```
    **When/where it's used:**  
    - Larger teams with scheduled releases.  
    - Projects needing strict versioning and multiple environments.

    **Pros:**  
    - Clear structure for releases and hotfixes.  
    - Good for complex projects with multiple parallel efforts.  

    **Cons:**  
    - Heavy process, slower merges.  
    - Not ideal for continuous deployment.  
    - Long-lived branches can cause merge conflicts.  

### 2. GitHub Flow
**How it works:**  
- One long-lived branch (`main`).  
- Developers create short-lived `feature` branches.  
- Work is merged into `main` via pull requests after review and testing.  
- Deployment happens directly from `main`.

    **Diagram (text-based):**
    ```bash
    main ────●─────────────●─────────────●─────────────
           \
            → feature branch → pull request → merge back
    ```

    **When/where used:**  
    - Small teams, startups, open-source projects.  
    - Continuous deployment environments.

    **Pros:**  
    - Simple and lightweight.  
    - Encourages fast iteration and deployment.  
    - Easy to understand and adopt.  

    **Cons:**  
    - Less structure for scheduled releases.  
    - Requires strong automated testing to avoid breaking production.  


---

### 3. Trunk-Based Development
**How it works:**  
- Everyone commits directly to `main` (the trunk).  
- Short-lived branches may exist but are merged quickly (often daily).  
- Focus on small, frequent commits and continuous integration.

    **Diagram (text-based):**
    ```bash
    main (trunk) ──●─●─●─●─●─●─●─●─●─●─●─●─●─●─●
    (developers commit directly or merge short-lived branches quickly)

    ```
    **When/where it's used:**  
    - Teams practicing CI/CD.  
    - Fast-moving projects with strong test automation.  
    - Works best with small, disciplined teams.

    **Pros:**  
    - Enables rapid delivery and integration.  
    - Reduces merge conflicts.  
    - Aligns well with DevOps and CI/CD.  

    **Cons:**  
    - Risky without strong automated testing.  
    - Not ideal for very large or fragmented teams.  
    - Merge conflicts can be frequent if discipline is lacking. 

4. Answer:
   - Which strategy would you use for a startup shipping fast?

   → **GitHub Flow** or **Trunk-Based Development** (lightweight, fast iteration, CI/CD friendly).

   - Which strategy would you use for a large team with scheduled releases?

   → **GitFlow** (structured, supports release cycles and hotfixes).

   - Which one does your favorite open-source project use? (check any repo on GitHub)

    → Most open-source projects on GitHub use **GitHub Flow** (main branch + feature branches, pull requests).

---