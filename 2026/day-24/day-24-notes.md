# Advanced Git: Merge, Rebase, Stash & Cherry Pick

### Task 1: Git Merge — Hands-On
1. Create a new branch `feature-login` from `main`, add a couple of commits to it
```bash
git branch     
  feature-1
* master

git checkout -b feature-login
Switched to a new branch 'feature-login'

git branch
  feature-1
* feature-login
  master
```
```bash
vim login-page

cat login-page 
Login
```
```bash
git add . 

git commit -m "feat:Add login page"
[feature-login f8f26ef] feat:Add login page
 1 file changed, 1 insertion(+)
 create mode 100644 login-page
```
```bash
vim login-page                     
cat login-page 
Login

Logging Successful..!!
```
```bash
git add .
git commit -m "Implement login validation" login-page 
[feature-login 4c582c0] Implement login validation
 1 file changed, 2 insertions(+)
```
```bash
git log --oneline
4c582c0 (HEAD -> feature-login) Implement login validation
f8f26ef feat:Add login page
54647af (master) feat:Added index.html
b786bdd chore: updated few more commands
17fbb82 (origin/feature-1, feature-1) Remove test line from git-commands.md
1bf390c chore: minor testing for feature-1
ddf5a9a (origin/master) Added definition for git status and git log command
734a3b0 Added definition for git add command
c8d0cc8 Added defination for git add command and few minor changes in formatting
74a4ae5 Added defination for Setup commands and added new commands for workflow and viewing changes
0bbf0be First commit for git-commands.md
```

2. Switch back to `main` and merge `feature-login` into `main`
```bash
git checkout master
Switched to branch 'master'
```
```bash
git merge feature-login
Updating 54647af..4c582c0
Fast-forward
 login-page | 3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 login-page
```
3. Observe the merge — did Git do a **fast-forward** merge or a **merge commit**?

    Since `main` hasn’t moved forward since we branched, Git will do a **fast-forward merge.**

    That means it simply moves the `main` pointer forward to the tip of `feature-login` — no new commit is created.


4. Now create another branch `feature-signup`, add commits to it — but also add a commit to `main` before merging
```bash
git checkout -b feature-signup
Switched to a new branch 'feature-signup'

git branch
  feature-1
  feature-login
* feature-signup
  master
```
```bash
vim signup

cat signup
Signup..
```
```bash
git add .

git commit -m "Add signup page" signup 


[feature-signup fb1c676] Add signup page
 1 file changed, 1 insertion(+)
 create mode 100644 signup
```
```bash
vim signup                            
cat signup 
Signup..


Signing up Successful!!

git add .                             

git commit -m "Implement signup validation" signup 
[feature-signup 7638ef7] Implement signup validation
 1 file changed, 3 insertions(+)
```
```bash
git log --oneline
7638ef7 (HEAD -> feature-signup) Implement signup validation
fb1c676 Add signup page
4c582c0 (feature-login) Implement login validation
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
touch README.md

git add .

git commit -m "Update README with project setup"
[master 877e568] Update README with project setup
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 README.md
```
```bash
git log --oneline
877e568 (HEAD -> master) Update README with project setup
4c582c0 (feature-login) Implement login validation
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
git branch
  feature-1
  feature-login
  feature-signup
* master

git merge feature-signup
Merge made by the 'ort' strategy.
 signup | 4 ++++
 1 file changed, 4 insertions(+)
 create mode 100644 signup
```
5. Merge `feature-signup` into `main` — what happens this time?

    This time Git cannot fast-forward, because `main` has diverged (it has its own commit not in `feature-signup`).
    
    So Git creates a **merge commit** that ties both histories together.

6. Answer in your notes:
   - What is a fast-forward merge?
   - When does Git create a merge commit instead?
   - What is a merge conflict? (try creating one intentionally by editing the same line in both branches)

    | Concept            | Explanation                                                                 |
    |--------------------|-----------------------------------------------------------------------------|
    | Fast-forward merge | Happens when the branch being merged is directly ahead of the current branch. Git just moves the pointer forward — no new commit is created. |
    | Merge commit       | Created when branches have diverged. Git makes a special commit with two parents to combine histories. |
    | Merge conflict     | Occurs when changes in two branches affect the same part of a file differently. Git cannot decide which version to keep, so it asks you to resolve manually. |

```bash
cat login-page 
Login

Logging Successful..!!
vim login-page 
cat login-page 
Login

Logging Successfully done..!!
```
```bash
git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   login-page

no changes added to commit (use "git add" and/or "git commit -a")

git add login-page 

git commit -m "chore: Minor update to Login message" login-page 
[master 69dd67f] chore: Minor update to Login message
 1 file changed, 1 insertion(+), 1 deletion(-)
```
```bash
git log --oneline
69dd67f (HEAD -> master) chore: Minor update to Login message
dc34325 Merge branch 'feature-signup'
877e568 Update README with project setup
7638ef7 (feature-signup) Implement signup validation
fb1c676 Add signup page
4c582c0 (feature-login) Implement login validation
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
git branch
  feature-1
  feature-login
  feature-signup
* master

git switch feature-login
Switched to branch 'feature-login'
```
```bash
cat login-page 
Login

Logging Successful..!!
vim login-page 
cat login-page 
Login

Logging Failed..!!
```
```bash
git add login-page 

git commit -m "chore: Modified login message in feature-login" login-page 
[feature-login f82ddfd] chore: Modified login message in feature-login
 1 file changed, 1 insertion(+), 1 deletion(-)
```
```bash
git log --oneline
f82ddfd (HEAD -> feature-login) chore: Modified login message in feature-login
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
git switch master
Switched to branch 'master'
```
```bash
git merge feature-login
Auto-merging login-page
CONFLICT (content): Merge conflict in login-page
Automatic merge failed; fix conflicts and then commit the result.

```
```bash
vim login-page 

cat login-page 
Login

Logging Successfully done..!!
```
```bash
git status
On branch master
You have unmerged paths.
  (fix conflicts and run "git commit")
  (use "git merge --abort" to abort the merge)

Unmerged paths:
  (use "git add <file>..." to mark resolution)
	both modified:   login-page

no changes added to commit (use "git add" and/or "git commit -a")

git add login-page 
```
```bash
git commit
[master 5c926db] Merge branch 'feature-login'
```
```bash
git log --oneline
5c926db (HEAD -> master) Merge branch 'feature-login'
f82ddfd (feature-login) chore: Modified login message in feature-login
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
---

### Task 2: Git Rebase — Hands-On
1. Create a branch `feature-dashboard` from `main`, add 2-3 commits
```bash
git branch
  feature-1
  feature-login
  feature-signup
* master

git checkout -b feature-dashboard
Switched to a new branch 'feature-dashboard'
```
```bash
touch dashboard

echo "layout" >> dashboard 

git status
On branch feature-dashboard
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	dashboard

nothing added to commit but untracked files present (use "git add" to track)

git add .
git commit -m "chore:Add dashboard layout" dashboard 
[feature-dashboard 1004520] chore:Add dashboard layout
 1 file changed, 1 insertion(+)
 create mode 100644 dashboard
```
```bash
echo "dashboard widgets" >> dashboard
git add .                            
git commit -m "chore: Implement dashboard widgets"
[feature-dashboard 1125976] chore: Implement dashboard widgets
 1 file changed, 1 insertion(+)
```
```bash
echo "Dashboard Styling" >> dashboard 
git add .
git commit -m "Add dashboard styling" dashboard 
[feature-dashboard 0df2af3] Add dashboard styling
 1 file changed, 1 insertion(+)
```
```bash
git log --oneline
0df2af3 (HEAD -> feature-dashboard) Add dashboard styling
1125976 chore: Implement dashboard widgets
1004520 chore:Add dashboard layout
5c926db (master) Merge branch 'feature-login'
f82ddfd (feature-login) chore: Modified login message in feature-login
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
2. While on `main`, add a new commit (so `main` moves ahead)
```bash
git checkout master
Switched to branch 'master'
echo "Dashboard Added" >> README.md 
git add .
git commit -m "Update README with dashboard info"
[master bd4ecbc] Update README with dashboard info
 1 file changed, 1 insertion(+)
```
```bash
git log --oneline
bd4ecbc (HEAD -> master) Update README with dashboard info
5c926db Merge branch 'feature-login'
f82ddfd (feature-login) chore: Modified login message in feature-login
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
3. Switch to `feature-dashboard` and rebase it onto `main`
```bash
git checkout feature-dashboard
Switched to branch 'feature-dashboard'
git rebase master             
Successfully rebased and updated refs/heads/feature-dashboard.
```
4. Observe your `git log --oneline --graph --all` — how does the history look compared to a merge?
```bash
git log --oneline --graph --all
* 26810ff (HEAD -> feature-dashboard) Add dashboard styling
* 8c1938c chore: Implement dashboard widgets
* c8960ea chore:Add dashboard layout
* bd4ecbc (master) Update README with dashboard info
*   5c926db Merge branch 'feature-login'
|\  
| * f82ddfd (feature-login) chore: Modified login message in feature-login
* | 69dd67f chore: Minor update to Login message
* |   dc34325 Merge branch 'feature-signup'
|\ \  
| * | 7638ef7 (feature-signup) Implement signup validation
| * | fb1c676 Add signup page
| |/  
* / 877e568 Update README with project setup
|/  
* 4c582c0 Implement login validation
* f8f26ef feat:Add login page
* 54647af feat:Added index.html
* b786bdd chore: updated few more commands
* 17fbb82 (origin/feature-1, feature-1) Remove test line from git-commands.md
* 1bf390c chore: minor testing for feature-1
* ddf5a9a (origin/master) Added definition for git status and git log command
* 734a3b0 Added definition for git add command
* c8d0cc8 Added defination for git add command and few minor changes in formatting
* 74a4ae5 Added defination for Setup commands and added new commands for workflow and viewing changes
* 0bbf0be First commit for git-commands.md
```
5. Answer in your notes:
   - What does rebase actually do to your commits?

   It takes the commits from our branch and re-applies them on top of another branch (usually `main`). This rewrites commit history.

   - How is the history different from a merge?

   Merge preserves branching history and creates a merge commit. Rebase creates a linear history, as if the branch’s commits happened after the target branch’s commits.

   - Why should you **never rebase commits that have been pushed and shared** with others?

   Because rebase rewrites commit history. If others have already based work on those commits, rewriting them causes confusion and conflicts when syncing.

   - When would you use rebase vs merge?

   **Rebase:** When you want a clean, linear history (often for feature branches before pushing). 
   
   **Merge:** When you want to preserve the true history of how branches diverged and came together (especially for shared/public branches).

---

### Task 3: Squash Commit vs Merge Commit
1. Create a branch `feature-profile`, add 4-5 small commits (typo fix, formatting, etc.)
```bash
git branch
  feature-1
* feature-dashboard
  feature-login
  feature-signup
  master

git checkout -b feature-profile   
Switched to a new branch 'feature-profile'
```
```bash
touch profile-page

echo "Fixed Type" >> profile-page 
git add .
git commit -m "chore:Fix typo in profile page" profile-page 
[feature-profile 0afae78] chore:Fix typo in profile page
 1 file changed, 1 insertion(+)
 create mode 100644 profile-page
```
```bash
echo "Profile formatting" >> profile-page 
git add .
git commit -m "chore:Update profile formatting"
[feature-profile 42abe64] chore:Update profile formatting
 1 file changed, 1 insertion(+)
```
```bash
echo "Modified CSS style" >> profile-page 
git add .
git commit -m "chore:Refactor profile CSS" profile-page 
[feature-profile e702ac6] chore:Refactor profile CSS
 1 file changed, 1 insertion(+)
```
```bash
echo "Text tweak" >> profile-page 
git add .
git commit -m "chore:Minor text tweak in profile" profile-page 
[feature-profile 3fa4253] chore:Minor text tweak in profile
 1 file changed, 1 insertion(+)
```
```bash
git log --oneline
3fa4253 (HEAD -> feature-profile) chore:Minor text tweak in profile
e702ac6 chore:Refactor profile CSS
42abe64 chore:Update profile formatting
0afae78 chore:Fix typo in profile page
26810ff (feature-dashboard) Add dashboard styling
8c1938c chore: Implement dashboard widgets
c8960ea chore:Add dashboard layout
bd4ecbc (master) Update README with dashboard info
5c926db Merge branch 'feature-login'
f82ddfd (feature-login) chore: Modified login message in feature-login
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
2. Merge it into `main` using `--squash` — what happens?
```bash
git checkout master
Switched to branch 'master'
git merge --squash feature-profile
Updating bd4ecbc..3fa4253
Fast-forward
Squash commit -- not updating HEAD
 dashboard    | 3 +++
 profile-page | 4 ++++
 2 files changed, 7 insertions(+)
 create mode 100644 dashboard
 create mode 100644 profile-page

git commit -m "feat:Add profile feature (squashed)"
[master 97d74ee] feat:Add profile feature (squashed)
 2 files changed, 7 insertions(+)
 create mode 100644 dashboard
 create mode 100644 profile-page
```
3. Check `git log` — how many commits were added to `main`?
```bash
git log --oneline
97d74ee (HEAD -> master) feat:Add profile feature (squashed)
bd4ecbc Update README with dashboard info
5c926db Merge branch 'feature-login'
f82ddfd (feature-login) chore: Modified login message in feature-login
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

- Git collects all changes from  into our working directory.
- Instead of creating multiple commits, we make one single commit that represents all those changes.
- `git log`	 on `master` will show only one new commit, not 4.

4. Now create another branch `feature-settings`, add a few commits
```bash
git checkout -b feature-settings master
Switched to a new branch 'feature-settings'
```
```bash
touch settings
git add .
git commit -m "feat: Add settings page" settings 
[feature-settings f98b49b] feat: Add settings page
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 settings
```
```bash
echo "Validation" >> settings 
git add .
git commit -m "chore:Implement settings validation" settings 
[feature-settings e03ba39] chore:Implement settings validation
 1 file changed, 1 insertion(+)
```
```bash
echo "Improve UI" >> settings 
git add .
git commit -m "chore:Improve settings UI" settings 
[feature-settings 8c9748f] chore:Improve settings UI
 1 file changed, 1 insertion(+)
```
```bash
git log --oneline
8c9748f (HEAD -> feature-settings) chore:Improve settings UI
e03ba39 chore:Implement settings validation
f98b49b feat: Add settings page
97d74ee (master) feat:Add profile feature (squashed)
bd4ecbc Update README with dashboard info
5c926db Merge branch 'feature-login'
f82ddfd (feature-login) chore: Modified login message in feature-login
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

5. Merge it into `main` **without** `--squash` (regular merge) — compare the history
```bash
git checkout master
Switched to branch 'master'

git merge feature-settings
Updating 97d74ee..8c9748f
Fast-forward
 settings | 2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 settings
```
```bash
git log --oneline --graph --all
* 8c9748f (HEAD -> master, feature-settings) chore:Improve settings UI
* e03ba39 chore:Implement settings validation
* f98b49b feat: Add settings page
* 97d74ee feat:Add profile feature (squashed)
| * 3fa4253 (feature-profile) chore:Minor text tweak in profile
| * e702ac6 chore:Refactor profile CSS
| * 42abe64 chore:Update profile formatting
| * 0afae78 chore:Fix typo in profile page
| * 26810ff (feature-dashboard) Add dashboard styling
| * 8c1938c chore: Implement dashboard widgets
| * c8960ea chore:Add dashboard layout
|/  
* bd4ecbc Update README with dashboard info
*   5c926db Merge branch 'feature-login'
|\  
| * f82ddfd (feature-login) chore: Modified login message in feature-login
* | 69dd67f chore: Minor update to Login message
* |   dc34325 Merge branch 'feature-signup'
|\ \  
| * | 7638ef7 (feature-signup) Implement signup validation
| * | fb1c676 Add signup page
| |/  
* / 877e568 Update README with project setup
|/  
* 4c582c0 Implement login validation
* f8f26ef feat:Add login page
* 54647af feat:Added index.html
* b786bdd chore: updated few more commands
* 17fbb82 (origin/feature-1, feature-1) Remove test line from git-commands.md
* 1bf390c chore: minor testing for feature-1
* ddf5a9a (origin/master) Added definition for git status and git log command
* 734a3b0 Added definition for git add command
* c8d0cc8 Added defination for git add command and few minor changes in formatting
* 74a4ae5 Added defination for Setup commands and added new commands for workflow and viewing changes
* 0bbf0be First commit for git-commands.md
```

- Git merges the branch normally.
- All individual commits from  are preserved in history.
- If  had diverged, we would have also see a merge commit tying them together.

6. Answer in your notes:
   - What does squash merging do?

   It combines all commits from a branch into a single commit when merging into the target branch.

   - When would you use squash merge vs regular merge?

   **Squash merge:** When you want a clean history, especially for feature branches with many small commits (typos, formatting, WIP). 

   **Regular merge:** When you want to preserve the full commit history of the branch, showing all steps of development.

   - What is the trade-off of squashing?
   
    **Pros:** Cleaner history, easier to read logs, avoids clutter from trivial commits. <br> 
     
    **Cons:** You lose the granular commit history of the branch, making it harder to trace individual changes later.

---

### Task 4: Git Stash — Hands-On
1. Start making changes to a file but **do not commit**
```bash
echo "Login to..." >> login-page 
cat login-page 
Login

Logging Failed..!!
Login to...
```
2. Now imagine you need to urgently switch to another branch — try switching. What happens?
```bash
git switch master
error: Your local changes to the following files would be overwritten by checkout:
	login-page
Please commit your changes or stash them before you switch branches.
Aborting
```
3. Use `git stash` to save your work-in-progress
```bash
git stash 
Saved working directory and index state WIP on feature-login: f82ddfd chore: Modified login message in feature-login
```
4. Switch to another branch, do some work, switch back
```bash
git checkout master
Switched to branch 'master'
echo "Some Change.." >> index.html 

git add .

git commit -m "feat:Some changes made in index.html" index.html 
[master 523dba5] feat:Some changes made in index.html
 1 file changed, 1 insertion(+)
```
```bash
git checkout feature-login
Switched to branch 'feature-login'
```
5. Apply your stashed changes using `git stash pop`
```bash
git stash pop
On branch feature-login
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   login-page

no changes added to commit (use "git add" and/or "git commit -a")
Dropped refs/stash@{0} (ba5955c182882a19c8f25cd18bfabca0e06976d3)

git add .

git commit -m "chore:added some feature-01" login-page 
[feature-login eae4d0f] chore:added some feature-01
 1 file changed, 1 insertion(+)
```
6. Try stashing multiple times and list all stashes
```bash
echo "Minor modification to Login-1" >> login-page        

git stash push -m "Stashing minor modification to Login-1"
Saved working directory and index state On feature-profile: Stashing minor modification to Login-1

git switch master                                     
Switched to branch 'master'

git checkout feature-login                            
Switched to branch 'feature-login'

echo "New upate Login-2" >> login-page

git stash push -m "New update Login-2"        
Saved working directory and index state On feature-login: New update Login-2

git checkout feature-profile                          
Switched to branch 'feature-profile'

git checkout feature-login            
Switched to branch 'feature-login'

git stash list                                            
stash@{0}: On feature-login: New update Login-2
stash@{1}: On feature-profile: Stashing minor modification to Login-1

```
7. Try applying a specific stash from the list
```bash
git stash apply stash@{0}             
On branch feature-login
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   login-page

no changes added to commit (use "git add" and/or "git commit -a")

git add .

git commit -m "chore:New update for feature Login-2" login-page 
[feature-login c7d11ab] chore:New update for feature Login-2
 1 file changed, 1 insertion(+)

cat login-page 
Login

Logging Failed..!!
Login to...
Login to 1..
New upate Login-2

git stash list
stash@{0}: On feature-login: New update Login-2
stash@{1}: On feature-profile: Stashing minor modification to Login-1

```
8. Answer in your notes:
   - What is the difference between `git stash pop` and `git stash apply`?

    **git stash pop:** restores the stash and removes it from the stash list.
    
    **git statsh apply:** restores the stash but keeps it in the list for future use.


   - When would you use stash in a real-world workflow?

    When we’re in the middle of work but need to switch branches urgently (e.g., to fix a bug on `main` ).

    When we want to experiment without committing. 

    When you need to temporarily shelve changes before pulling updates or rebasing.

---

### Task 5: Cherry Picking
1. Create a branch `feature-hotfix`, make 3 commits with different changes
```bash
git checkout -b feature-hotfix master
Switched to a new branch 'feature-hotfix'

touch patch

echo "Fix typo in header" > patch

git add .

git commit -m "Hotfix: Fix typo in header" patch
[feature-hotfix b32c124] Hotfix: Fix typo in header
 1 file changed, 1 insertion(+)
 create mode 100644 patch
```
```bash
echo "Correct API endpoint" >> patch

git add .

git commit -m "Hotfix: Correct API endpoint" patch
[feature-hotfix e792f4a] Hotfix: Correct API endpoint
 1 file changed, 1 insertion(+)
```
```bash
echo "Update error message" >> patch

git add .

git commit -m "Hotfix: Update error message" patch
[feature-hotfix 0e7aecf] Hotfix: Update error message
 1 file changed, 1 insertion(+)
```
2. Switch to `main`
```bash
git switch master
Switched to branch 'master'

git log --oneline
523dba5 (HEAD -> master) feat:Some changes made in index.html
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
3. Cherry-pick **only the second commit** from `feature-hotfix` onto `main`
```bash
git log feature-hotfix --oneline
0e7aecf (feature-hotfix) Hotfix: Update error message
e792f4a Hotfix: Correct API endpoint
b32c124 Hotfix: Fix typo in header
523dba5 (HEAD -> master) feat:Some changes made in index.html
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
git cherry-pick e792f4a
CONFLICT (modify/delete): patch deleted in HEAD and modified in e792f4a (Hotfix: Correct API endpoint).  Version e792f4a (Hotfix: Correct API endpoint) of patch left in tree.
error: could not apply e792f4a... Hotfix: Correct API endpoint
hint: After resolving the conflicts, mark them with
hint: "git add/rm <pathspec>", then run
hint: "git cherry-pick --continue".
hint: You can instead skip this commit with "git cherry-pick --skip".
hint: To abort and get back to the state before "git cherry-pick",
hint: run "git cherry-pick --abort".
hint: Disable this message with "git config set advice.mergeConflict false"
```
```bash
 git status
On branch master
You are currently cherry-picking commit e792f4a.
  (fix conflicts and run "git cherry-pick --continue")
  (use "git cherry-pick --skip" to skip this patch)
  (use "git cherry-pick --abort" to cancel the cherry-pick operation)

Unmerged paths:
  (use "git add/rm <file>..." as appropriate to mark resolution)
	deleted by us:   patch

no changes added to commit (use "git add" and/or "git commit -a")

git add patch 

git cherry-pick --continue
[master c723214] Hotfix: Correct API endpoint. Conflict resolved.
 Date: Thu Feb 19 06:01:37 2026 +0530
 1 file changed, 2 insertions(+)
 create mode 100644 patch
```
4. Verify with `git log` that only that one commit was applied
```bash
git log --oneline
c723214 (HEAD -> master) Hotfix: Correct API endpoint. Conflict resolved.
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
   - What does cherry-pick do?

   It takes a single commit (or a range of commits) from one branch and applies it onto another branch, preserving the commit’s changes but creating a new commit with a different hash.

   - When would you use cherry-pick in a real project?

   To quickly bring a bug fix from one branch into another without merging the entire branch.
   
   To selectively apply commits from a feature branch into `main` or a release branch.

   - What can go wrong with cherry-picking?

   **Conflicts:** If the same code has changed differently in both branches, we’ll need to resolve conflicts manually. 
   
   **Duplicate commits:** If we later merge the branch, we may end up with duplicate changes in history. 
   
   **Messy history:** Overusing cherry-pick can make commit history harder to follow compared to merges or rebases.

---