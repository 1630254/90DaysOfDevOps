# Practice user and group management

## Users & Groups Created
- Users: tokyo, berlin, professor, nairobi
- Groups: developers, admins, project-team

## Group Assignments
Assign users:
- `tokyo` → `developers` + `project-team`
- `berlin` → `developers` + `admins` (both groups)
- `professor` → `admins`
- `nairobi` → `project-team`

## Directories Created
List directories with permissions
- `/opt/dev-project/` → root:developers → 755
- `/opt/team-workspace/` → root:project-team → 775

## Commands Used

### Task 1: Create Users

Create three users with home directories and passwords:
- `tokyo`
- `berlin`
- `professor`

``` bash
sudo useradd -m tokyo
sudo passwd tokyo
New password: 
Retype new password: 
passwd: password updated successfully
```
```bash
sudo useradd -m berlin
udo passwd berlin
New password: 
Retype new password: 
passwd: password updated successfully
```
```bash
sudo useradd -m professor
sudo passwd professor
New password: 
Retype new password: 
passwd: password updated successfully
```

**Verify:** Check `/etc/passwd` and `/home/` directory
```bash
`tail /etc/passwd`
tcpdump:x:107:108::/nonexistent:/usr/sbin/nologin
landscape:x:108:109::/var/lib/landscape:/usr/sbin/nologin
fwupd-refresh:x:990:990:Firmware update daemon:/var/lib/fwupd:/usr/sbin/nologin
polkitd:x:989:989:User for polkitd:/:/usr/sbin/nologin
ec2-instance-connect:x:109:65534::/nonexistent:/usr/sbin/nologin
_chrony:x:110:112:Chrony daemon,,,:/var/lib/chrony:/usr/sbin/nologin
ubuntu:x:1000:1000:Ubuntu:/home/ubuntu:/bin/bash
tokyo:x:1001:1001::/home/tokyo:/bin/sh
berlin:x:1002:1002::/home/berlin:/bin/sh
professor:x:1003:1003::/home/professor:/bin/sh
```
```bash
ls -l /home
total 16
drwxr-x--- 2 berlin    berlin    4096 Feb  4 23:53 berlin
drwxr-x--- 2 professor professor 4096 Feb  4 23:53 professor
drwxr-x--- 2 tokyo     tokyo     4096 Feb  4 23:52 tokyo
drwxr-x--- 4 ubuntu    ubuntu    4096 Feb  4 23:52 ubuntu
```

### Task 2: Create Groups

Create two groups:
- `developers`
- `admins`
```bash
sudo groupadd developers
sudo groupadd admins
```

**Verify:** Check `/etc/group`
```bash
tail /etc/group
polkitd:x:989:
admin:x:110:
netdev:x:111:
_chrony:x:112:
ubuntu:x:1000:
tokyo:x:1001:
berlin:x:1002:
professor:x:1003:
developers:x:1004:
admins:x:1005:
```

### Task 3: Assign to Groups

Assign users:
- `tokyo` → `developers`
- `berlin` → `developers` + `admins` (both groups)
- `professor` → `admins`
```bash
sudo usermod -aG developers tokyo
sudo usermod -aG developers,admins berlin
sudo usermod -aG admins professor
```

**Verify:** Use appropriate command to check group membership
```bash
tail /etc/group
polkitd:x:989:
admin:x:110:
netdev:x:111:
_chrony:x:112:
ubuntu:x:1000:
tokyo:x:1001:
berlin:x:1002:
professor:x:1003:
developers:x:1004:tokyo,berlin
admins:x:1005:berlin,professor
```
### Task 4: Shared Directory

1. Create directory: `/opt/dev-project`
```bash
sudo mkdir -p /opt/dev-project
```
2. Set group owner to `developers`
```bash
sudo chown :developers /opt/dev-project/
```
3. Set permissions to `775` (rwxrwxr-x)
```bash
sudo chmod 755 /opt/dev-project/
```
4. Test by creating files as `tokyo` and `berlin`

```bash
sudo su - tokyo
touch /opt/dev-project/tokyo
touch: cannot touch '/opt/dev-project/tokyo': Permission denied
```
```bash
sudo su - berlin
touch /opt/dev-project/berlin
touch: cannot touch '/opt/dev-project/berlin': Permission denied
```

**Verify:** Check permissions and test file creation
```bash
ls -ld /opt/dev-project/
drwxr-xr-x 2 root developers 4096 Feb  5 00:13  

ls -l /opt/dev-project/
total 0
```

### Task 5: Team Workspace

1. Create user `nairobi` with home directory
```bash
sudo useradd -m nairobi
```
2. Create group `project-team`
```bash
sudo groupadd project-team
```
3. Add `nairobi` and `tokyo` to `project-team`
```bash
sudo usermod -aG project-team nairobi
sudo usermod -aG project-team tokyo
```
```bash
tail /etc/group
netdev:x:111:
_chrony:x:112:
ubuntu:x:1000:
tokyo:x:1001:
berlin:x:1002:
professor:x:1003:
developers:x:1004:tokyo,berlin
admins:x:1005:berlin,professor
nairobi:x:1006:
project-team:x:1007:nairobi,tokyo
```

4. Create `/opt/team-workspace` directory
```bash
sudo mkdir -p /opt/team-workspace
```
5. Set group to `project-team`, permissions to `775`
```bash
sudo chgrp project-team /opt/team-workspace/
sudo chmod 775 /opt/team-workspace/
ls -ld /opt/team-workspace/
drwxrwxr-x 2 root project-team 4096 Feb  5 00:37 /opt/team-workspace/
```
6. Test by creating file as `nairobi`
```bash
sudo  su - nairobi
touch /opt/team-workspace/nairobi
```
```bash
ls -l /opt/team-workspace/
total 0
-rw-rw-r-- 1 nairobi nairobi 0 Feb  5 00:52 nairobi
```


## What I Learned
**1. User and Group Management Basics**
-	We created new users (`tokyo`, `berlin`, `professor`, `nairobi`) with their own home directories.
- 	We verified their existence in `/etc/passwd` and confirmed their home directories under `/home`.
- 	You also created new groups ( `developers`, `admins`, `project-team`) and checked them in `/etc/group`.

This shows how Linux manages users and groups separately, and how each user automatically gets a primary group with the same name.

**2. Assigning Users to Secondary Groups**
- 	Using `usermod -aG`, we added users to supplementary groups ( `tokyo`→ `developers`, `berlin`→ `developers` + `admins`,  `professor`→ `admins`).
- 	The updated `/etc/group`  confirmed that users were successfully added as secondary members.

We learned the difference between primary group (set at user creation) and secondary groups (added later for shared permissions).

**3. Group Ownership and Directory Permissions**
-	You created shared directories (`/opt/dev-project`, `/opt/team-workspace`) and changed their group ownership with `chown :groupname`.
-	The  `/opt/dev-project` directory had `755` permissions, meaning only the owner (`root`) could write, while group members could only read/execute → hence `tokyo` and `berlin` got permission denied.
- 	The  directory `/opt/team-workspace` had `775` permissions, allowing group members (`project-team`) to create files successfully → demonstrated by nairobi creating a file.

We learned how directory group ownership + permissions (rwx) directly control collaboration between users.