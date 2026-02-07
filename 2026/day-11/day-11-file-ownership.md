# Day 11 Challenge

## Files & Directories Created

- devops-file.txt
- team-notes.txt
- project-config.yaml
- heist-project/vault/gold.txt
- heist-project/plans/strategy.conf
- bank-heist/access-codes.txt
- bank-heist/blueprints.pdf
- bank-heist/escape-plan.txt
- app-logs/
- heist-project/vault
- heist-project/plans
- bank-heist/


## Ownership Changes

- devops-file.txt: ubuntu:ubuntu → berlin:ubuntu →tokyo:ubuntu
- team-notes.txt: ubuntu:ubuntu → ubuntu:heist-team
- project-config.yaml: ubuntu:ubuntu → professor:heist-team
- heist-project/vault/gold.txt: ubuntu:ubuntu → professor:planners
- heist-project/plans/strategy.conf: ubuntu:ubuntu → professor:planners
- bank-heist/access-codes.txt: ubuntu:ubuntu → tokyo:vault-team
- bank-heist/blueprints.pdf: ubuntu:ubuntu → berlin:tech-team
- bank-heist/escape-plan.: ubuntu:ubuntu → nairobi:vault-team
- app-logs/: ubuntu:ubuntu → berlin:heist-team
- heist-project/vault: ubuntu:ubuntu → professor:planners
- heist-project/plans: ubuntu:ubuntu → professor:planners
- bank-heist/: ubuntu:ubuntu


## Commands Used

### Task 1: Understanding Ownership
1. Run `ls -l` in your home directory
    ```bash
    ls -l
    total 12
    -r--r--r-- 1 ubuntu ubuntu    0 Feb  6 15:12 devops.txt
    -rw-r----- 1 ubuntu ubuntu   36 Feb  6 15:18 notes.txt
    drwxr-xr-x 2 ubuntu ubuntu 4096 Feb  6 15:29 project
    -rwxrwxr-x 1 ubuntu ubuntu   20 Feb  6 15:17 script.sh
    ```
2. Identify the **owner** and **group** columns

- The 3rd column (`ubuntu`) represents the owner.
- The 4th column (`ubuntu`) represents the group.

3. Check who owns your files
- All the files are owned by user `ubuntu`

**Format:** `-rw-r--r-- 1 owner group size date filename`

Document: What's the difference between owner and group?

Owner
- The owner is the user who created the file (or who has been assigned ownership).
- The owner has a specific set of permissions defined in the first triplet of the permission string.
- Example: `ubuntu` → the owner has  (read-only).
- Ownership can be changed with  (change owner).

Group
- The group is a collection of users who share access rights to the file.
- The group permissions are defined in the second triplet of the permission string.
- Example: `ubuntu` → the group also has  (read-only).
- Groups are useful when multiple users need similar access to files without giving everyone full ownership.
- Group membership can be managed with 
---
### Task 2: Basic chown Operations 

1. Create file `devops-file.txt`
    ```bash
    touch devops-file.txt
    ```
2. Check current owner: `ls -l devops-file.txt`
    ```bash
    ls -l devops-file.txt
    -rw-rw-r-- 1 ubuntu ubuntu 0 Feb  6 15:49 devops-file.txt
    ```
3. Change owner to `tokyo` (create user if needed)
    ```bash
    useradd -m tokyo
    useradd: user 'tokyo' already exists
    ```
4. Change owner to `berlin`
    ```bash
    sudo chown berlin devops-file.txt
    ```
5. Verify the changes
    ```bash
    ls -l devops-file.txt
    -rw-rw-r-- 1 berlin ubuntu 0 Feb  6 15:49 devops-file.txt
    ```

**Try:**
```bash
sudo chown tokyo devops-file.txt
ls -l devops-file.txt 
-rw-rw-r-- 1 tokyo ubuntu 0 Feb  6 15:49 devops-file.txt
```
---
### Task 3: Basic chgrp Operations
1. Create file `team-notes.txt`
    ```bash
    touch team-notes.txt
    ```
2. Check current group: `ls -l team-notes.txt`
    ```bash
    ls -l team-notes.txt
    -rw-rw-r-- 1 ubuntu ubuntu 0 Feb  6 16:03 team-notes.txt
    ```
3. Create group: `sudo groupadd heist-team`
    ```bash
    sudo groupadd heist-team
    ```
4. Change file group to `heist-team`
    ```bash
    sudo chgrp heist-team team-notes.txt 
    ```
5. Verify the change
    ```bash
    ls -l team-notes.txt 
    -rw-rw-r-- 1 ubuntu heist-team 0 Feb  6 16:03 team-notes.txt
    ```
---
### Task 4: Combined Owner & Group Change

Using `chown` you can change both owner and group together:

1. Create file `project-config.yaml`
    ```bash
    touch project-config.yaml
    ```
2. Change owner to `professor` AND group to `heist-team` (one command)
    ```bash
    sudo chown  professor:heist-team team-notes.txt 
    ```
3. Create directory `app-logs/`
    ```bash
    mkdir app-logs/
    ```
4. Change its owner to `berlin` and group to `heist-team`
    ```bash
    sudo chown berlin:heist-team app-logs/
    ```
---
### Task 5: Recursive Ownership

1. Create directory structure:
   ```
   mkdir -p heist-project/vault
   mkdir -p heist-project/plans
   touch heist-project/vault/gold.txt
   touch heist-project/plans/strategy.conf
   ```
    ```bash
    mkdir -p heist-project/vault
    mkdir -p heist-project/plans
    touch heist-project/vault/gold.txt
    touch heist-project/plans/strategy.conf
    ```

2. Create group `planners`: `sudo groupadd planners`
    ```bash
    sudo groupadd planners
    ```

3. Change ownership of entire `heist-project/` directory:
   - Owner: `professor`
   - Group: `planners`
   - Use recursive flag (`-R`)

    ```bash
    sudo chown -R professor:planners heist-project/
    ```

4. Verify all files and subdirectories changed: `ls -lR heist-project/`
    ```bash
    ls -lR heist-project/
    heist-project/:
    total 8
    drwxrwxr-x 2 professor planners 4096 Feb  6 16:23 plans
    drwxrwxr-x 2 professor planners 4096 Feb  6 16:23 vault

    heist-project/plans:
    total 0
    -rw-rw-r-- 1 professor planners 0 Feb  6 16:23 strategy.conf

    heist-project/vault:
    total 0
    -rw-rw-r-- 1 professor planners 0 Feb  6 16:23 gold.txt
    ```
---
### Task 6: Practice Challenge

1. Create users: `tokyo`, `berlin`, `nairobi` (if not already created)
    ```bash
    useradd -m tokyo
    useradd: user 'tokyo' already exists
    useradd -m berlin
    useradd: user 'berlin' already exists
    useradd -m nairobi
    useradd: user 'nairobi' already exists
    ```
2. Create groups: `vault-team`, `tech-team`
    ```bash
    sudo groupadd vault-team
    sudo groupadd tech-team
    ```
3. Create directory: `bank-heist/`
    ```bash
    mkdir bank-heist/
    ```
4. Create 3 files inside:
   ```
   touch bank-heist/access-codes.txt
   touch bank-heist/blueprints.pdf
   touch bank-heist/escape-plan.txt
   ```
    ```bash
    touch bank-heist/access-codes.txt
    touch bank-heist/blueprints.pdf
    touch bank-heist/escape-plan.txt
    ```
5. Set different ownership:
   - `access-codes.txt` → owner: `tokyo`, group: `vault-team`
   - `blueprints.pdf` → owner: `berlin`, group: `tech-team`
   - `escape-plan.txt` → owner: `nairobi`, group: `vault-team`

    ```bash
    sudo chown tokyo:vault-team bank-heist/access-codes.txt
    sudo chown berlin:tech-team bank-heist/blueprints.pdf 
    sudo chown nairobi:vault-team bank-heist/escape-plan.txt 
    ```
**Verify:** `ls -l bank-heist/`
```bash
ls -l bank-heist/
total 0
-rw-rw-r-- 1 tokyo   vault-team 0 Feb  6 16:41 access-codes.txt
-rw-rw-r-- 1 berlin  tech-team  0 Feb  6 16:41 blueprints.pdf
-rw-rw-r-- 1 nairobi vault-team 0 Feb  6 16:41 escape-plan.txt
```
---
## What I Learned

**1. Ownership vs. Group Permissions**
- **Owner:** The individual user who owns the file; their permissions are defined in the `first triplet` of the permission string (e.g., `rw-`).
- **Group:** A collection of users; their permissions are defined in the `second triplet` (e.g.,`r--` ).
- **Key Insight:** Ownership is about _individual control_, while groups enable _shared access_ without transferring full ownership.

**2. Changing Ownership and Groups**
- `chown`→ Changes the **owner** of a file.
    - Example: `sudo chown tokyo devops-file.txt` → owner becomes `tokyo`.
- `chgrp`→ Changes the **group** of a file.
    - Example:  `sudo chgrp heist-team team-notes.txt`→ group becomes `heist-team` .
- **Combined Change:**  `chown owner:group file` lets user update both in one command.
    - Example: `sudo chown berlin:heist-team app-logs/`.

**3. Recursive Ownership for Directories**
- Using `chown -R owner:group directory/` applies ownership changes to all **files and subdirectories** inside.
    - Example: `sudo chown -R professor:planners heist-project/` → every file and folder under `heist-project` is updated.
- **Key Insight:** Recursive changes are powerful for managing large project structures, ensuring consistent access control across teams.
---