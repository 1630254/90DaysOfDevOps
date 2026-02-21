# GitHub CLI: Manage GitHub from Your Terminal

### Task 1: Install and Authenticate
1. Install the GitHub CLI on your machine
```bash
sudo dnf install gh -y

[sudo] password for student: 
Copr repo for PyCharm owned by phracek                                                                                                                                                                         15  B/s | 158  B     00:10    
Errors during downloading metadata for repository 'copr:copr.fedorainfracloud.org:phracek:PyCharm':
  - Status code: 404 for https://download.copr.fedorainfracloud.org/results/phracek/PyCharm/fedora-40-x86_64/repodata/repomd.xml (IP: 13.35.20.9)
Error: Failed to download metadata for repo 'copr:copr.fedorainfracloud.org:phracek:PyCharm': Cannot download repomd.xml: Cannot download repodata/repomd.xml: All mirrors were tried
Ignoring repositories: copr:copr.fedorainfracloud.org:phracek:PyCharm
Last metadata expiration check: 2:56:39 ago on Sat 21 Feb 2026 12:36:19 PM IST.
Dependencies resolved.
==============================================================================================================================================================================================================================================
 Package                                             Architecture                                            Version                                                           Repository                                                Size
==============================================================================================================================================================================================================================================
Installing:
 gh                                                  x86_64                                                  2.65.0-1.fc40                                                     updates                                                   11 M

Transaction Summary
==============================================================================================================================================================================================================================================
Install  1 Package

Total download size: 11 M
Installed size: 50 M
Downloading Packages:
gh-2.65.0-1.fc40.x86_64.rpm                                                                                                                                                                                   2.1 MB/s |  11 MB     00:04    
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                                                                         1.9 MB/s |  11 MB     00:05     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                                                                      1/1 
  Installing       : gh-2.65.0-1.fc40.x86_64                                                                                                                                                                                              1/1 
  Running scriptlet: gh-2.65.0-1.fc40.x86_64                                                                                                                                                                                              1/1 

Installed:
  gh-2.65.0-1.fc40.x86_64                                                                                                                                                                                                                     

Complete!
```
```bash
gh --version
gh version 2.65.0 (2025-01-06)
https://github.com/cli/cli/releases/tag/v2.65.0
```
2. Authenticate with your GitHub account
```bash
sudo gh auth login
? Where do you use GitHub? GitHub.com
? What is your preferred protocol for Git operations on this host? SSH
? Generate a new SSH key to add to your GitHub account? No
? How would you like to authenticate GitHub CLI? Login with a web browser

! First copy your one-time code: B39D-FDEB
Press Enter to open https://github.com/login/device in your browser...   
Running Firefox as root in a regular user's session is not supported.  ($XAUTHORITY is /run/user/1000/.mutter-Xwaylandauth.35MXK3 which is owned by student.)

✓ Authentication complete.
- gh config set -h github.com git_protocol ssh
✓ Configured git protocol
! Authentication credentials saved in plain text
✓ Logged in as 1630254
```
3. Verify you're logged in and check which account is active
```bash
gh auth status
github.com
  ✓ Logged in to github.com account 1630254 (keyring)
  - Active account: true
  - Git operations protocol: ssh
  - Token: gho_************************************
  - Token scopes: 'admin:public_key', 'gist', 'read:org', 'repo'
```

```bash
gh api user
{
  "login": "1630254",
  "id": 65387370,
  "node_id": "MDQ6VXNlcjY1Mzg3Mzcw",
  "avatar_url": "https://avatars.githubusercontent.com/u/65387370?v=4",
  "gravatar_id": "",
  "url": "https://api.github.com/users/1630254",
  "html_url": "https://github.com/1630254",
  "followers_url": "https://api.github.com/users/1630254/followers",
  "following_url": "https://api.github.com/users/1630254/following{/other_user}",
  "gists_url": "https://api.github.com/users/1630254/gists{/gist_id}",
  "starred_url": "https://api.github.com/users/1630254/starred{/owner}{/repo}",
  "subscriptions_url": "https://api.github.com/users/1630254/subscriptions",
  "organizations_url": "https://api.github.com/users/1630254/orgs",
  "repos_url": "https://api.github.com/users/1630254/repos",
  "events_url": "https://api.github.com/users/1630254/events{/privacy}",
  "received_events_url": "https://api.github.com/users/1630254/received_events",
  "type": "User",
  "user_view_type": "public",
  "site_admin": false,
  "name": "Manas B.",
  "company": null,
  "blog": "",
  "location": null,
  "email": null,
  "hireable": null,
  "bio": null,
  "twitter_username": null,
  "notification_email": null,
  "public_repos": 3,
  "public_gists": 0,
  "followers": 0,
  "following": 0,
  "created_at": "2020-05-15T06:18:03Z",
  "updated_at": "2026-02-20T14:51:46Z"
}
```
4. Answer in your notes: What authentication methods does `gh` support?

**GitHub CLI Authentication Methods**

| Method                | Use Case                                | Setup Command                                      | Details                                                                 |
|-----------------------|-----------------------------------------|---------------------------------------------------|-------------------------------------------------------------------------|
| **Web Browser**       | Interactive login (recommended for most users) | `gh auth login`                                   | Uses OAuth to store credentials securely; handles 2FA seamlessly.       |
| **Personal Access Token (PAT)** | Headless environments, automation, CI/CD | Set `GH_TOKEN` environment variable, or use `--with-token` flag | Requires generating a token via the GitHub Developer Settings page.     |
| **SSH Key**           | Git operations (alternative to HTTPS)   | Configured during `gh auth login` with the SSH protocol option | Used for Git commands, not direct CLI API interactions.                 |

---

### Task 2: Working with Repositories
1. Create a **new GitHub repo** directly from the terminal — make it public with a README
```bash
gh repo create my-test-repo --public --confirm --add-readme

Flag --confirm has been deprecated, Pass any argument to skip confirmation prompt
✓ Created repository 1630254/my-test-repo on GitHub
  https://github.com/1630254/my-test-repo
```
2. Clone a repo using `gh` instead of `git clone`
```bash
gh repo clone 1630254/my-test-repo

Cloning into 'my-test-repo'...
The authenticity of host 'github.com (20.207.73.82)' can't be established.
ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'github.com' (ED25519) to the list of known hosts.
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0 (from 0)
Receiving objects: 100% (3/3), done.
```
3. View details of one of your repos from the terminal
```bash
gh repo view 1630254/my-test-repo --json name,description,visibility

{
  "description": "",
  "name": "my-test-repo",
  "visibility": "PUBLIC"
}
```
4. List all your repositories
```bash
gh repo list

Showing 4 of 4 repositories in @1630254

NAME                         DESCRIPTION                                                                                                                                                                     INFO          UPDATED            
1630254/my-test-repo                                                                                                                                                                                         public        about 4 minutes ago
1630254/90DaysOfDevOps       This repository is a Challenge for the DevOps Community to get stronger in DevOps. This challenge starts on the 1st January 2023 and in the next 90 Days we promise ourselv...  public, fork  about 1 day ago
1630254/devops-git-practice  Used for git command practice                                                                                                                                                   public        about 5 days ago
1630254/python-for-devops    Python For DevOps [AI Edition] is a hands-on, beginner-friendly live course that teaches you the exact Python skills needed to automate real DevOps workflows, build tools,...  public, fork  about 1 month ago
```
5. Open a repo in your browser directly from the terminal
```bash
gh repo view 1630254/my-test-repo --web

Opening https://github.com/1630254/my-test-repo in your browser.
```
6. Delete the test repo you created (be careful!)
```bash
gh repo delete 1630254/my-test-repo

? Type 1630254/my-test-repo to confirm deletion: 1630254/my-test-repo
HTTP 403: Must have admin rights to Repository. (https://api.github.com/repos/1630254/my-test-repo)
This API operation needs the "delete_repo" scope. To request it, run:  gh auth refresh -h github.com -s delete_repo
[student@fedora]~% gh auth refresh -h github.com -s delete_repo

! First copy your one-time code: CFCA-85B9
Press Enter to open https://github.com/login/device in your browser... 
✓ Authentication complete.
```
```bash
gh repo delete 1630254/my-test-repo         

? Type 1630254/my-test-repo to confirm deletion: 1630254/my-test-repo
✓ Deleted repository 1630254/my-test-repo
```
---

### Task 3: Issues
1. Create an issue on one of your repos from the terminal — give it a title, body, and a label
```bash
git remote -v
origin	git@github.com:1630254/my-test-repo.git (fetch)
origin	git@github.com:1630254/my-test-repo.git (push)
[student@fedora]~/my-test-repo% gh repo create my-test-repo --public --source=. --remote=origin --push


✓ Created repository 1630254/my-test-repo on GitHub
  https://github.com/1630254/my-test-repo
X Unable to add remote "origin"
[student@fedora]~/my-test-repo% git remote -v                                                         
origin	git@github.com:1630254/my-test-repo.git (fetch)
origin	git@github.com:1630254/my-test-repo.git (push)
[student@fedora]~/my-test-repo% gh repo list

Showing 4 of 4 repositories in @1630254

NAME                         DESCRIPTION                                                                                                                                                                  INFO          UPDATED               
1630254/my-test-repo                                                                                                                                                                                      public        less than a minute ago
1630254/90DaysOfDevOps       This repository is a Challenge for the DevOps Community to get stronger in DevOps. This challenge starts on the 1st January 2023 and in the next 90 Days we promise ours...  public, fork  about 1 day ago
1630254/devops-git-practice  Used for git command practice                                                                                                                                                public        about 5 days ago
1630254/python-for-devops    Python For DevOps [AI Edition] is a hands-on, beginner-friendly live course that teaches you the exact Python skills needed to automate real DevOps workflows, build too...  public, fork  about 1 month ago
```
```bash
gh issue create \
  --title "Bug: Login fails on Safari" \
  --body "Steps to reproduce:\n1. Go to login page\n2. Enter credentials\n3. Observe error" \
  --label "bug"



Creating issue in 1630254/my-test-repo

https://github.com/1630254/my-test-repo/issues/1
```
2. List all open issues on that repo
```bash
gh issue list --state open

Showing 1 of 1 open issue in 1630254/my-test-repo

ID  TITLE                       LABELS  UPDATED           
#1  Bug: Login fails on Safari  bug     about 1 minute ago
```
3. View a specific issue by its number
```bash
 gh issue view #1 --web
Opening https://github.com/1630254/my-test-repo/issues/1 in your browser.
```
4. Close an issue from the terminal
```bash
gh issue close #1 --comment "Bug fixed done for the open issue #1"
✓ Closed issue 1630254/my-test-repo#1 (Bug: Login fails on Safari)
```
5. Answer in your notes: How could you use `gh issue` in a script or automation?

    We can integrate `gh issue` into Bash scripts or CI/CD pipelines to automate workflows. 

    For example:

    **Automated Bug Reporting:**

    A script could parse logs for errors and automatically create issues with `gh issue create`.

    **Daily Status Reports:**

    Use `gh issue list --state open --json title,number` in a cron job to generate a report of unresolved issues.


    **Auto‑closing Issues:**

    After successful deployment, a script could run `gh issue close <number>` for issues linked to that release.

    Because `gh` supports JSON output (`--json`), you can pipe results into tools like `jq` for structured automation.

---
