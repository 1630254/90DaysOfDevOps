# Mini Self-Check

## Time saving commands

1. `ssh -i <key.pem> user@host`
- **Why it saves time:**
Remote access to servers.
- **Time-saver use case:** Central command for troubleshooting across environments.

2. `top / htop`
- **Why it saves time:**
Real-time CPU/memory usage monitoring.
- **Time-saver use case:** Immediate visibility into system bottlenecks.

3. `df -h`
- **Why it saves time:**
Human-readable disk space usage across mounts.
- **Time-saver use case:** Prevents outages by spotting full partitions early.

3. `du -sh`
- **Why it saves time:**
Summarizes disk usage per directory.
- **Time-saver use case:** Quickly identifies space hogs

5. `tail -f <log_file>`
- **Why it saves time:**
Live log monitoring.
- **Time-saver use case:** Real-time debugging without reopening files.
---

## Service health check
### Step 1: Check service status
```bash
systemctl status <service>
```
- Confirms if the service is active (running), shows uptime, PID, and recent log entries.

### Step 2: Inspect logs
```bash
journalctl -u <service> -n 20
```
- Displays the last 20 log lines for the service.
- Helps spot errors, crashes, or misconfigurations right away
- `-f` to tail logs in real time

### Step 3: Verify process/resource usage
```bash
ps aux | grep <service>
```
- Confirms the process is actually running and shows CPU/memory usage
---
**In Practice:**
- If  `systemctl status` says active, and  `journalctl` shows no recent errors, the service is healthy.
- If logs show repeated failures or the process is missing in `ps`, we’ve got a problem to dig deeper into.


## Safely change ownership and permissions

### Principles for Safety
- **Check current state first:** Use `ls -l` to see existing ownership/permissions.
- **Change ownership before permissions:** Ensure the right user/group owns the file, then adjust access.
- **Use minimal permissions:** Grant only what’s needed (avoid `777` ).
- **Test access:** If it’s related to a service, restart or run it to confirm functionality.
---
**Example:**
Suppose we want to safely give ownership of a directory `/opt/team-workspace` to group `project-team` and allow read/execute for group members:
```bash
sudo chgrp project-team /opt/team-workspace/ && sudo chmod 750 /opt/team-workspace/
ls -ld /opt/team-workspace/
drwxr-x--- 2 root project-team 4096 Feb  5 00:37 /opt/team-workspace/
```
**Breakdown:**
- `chgrp project-team /opt/team-workspace` → Sets owner and group to .
- `chmod 750 /opt/team-workspace/` → Owner `root` has full rights, group `project-team` has read/execute, `others` have none.
- `&&` → ensures permissions are only applied if ownership change succeeds.

**Quick Comparison of Safety:**

| Step       | Command                          | Why Safe                                      |
|------------|----------------------------------|-----------------------------------------------|
| Inspect    | `ls -l /opt/team-workspace/`            | See current state before changes              |
| Ownership  | `chgrp project-team /opt/team-workspace/`  | Ensures correct group owns directory       |
| Permissions| `chmod 750 /opt/team-workspace/`     | Grants only necessary access, avoids overexposure |
---

## Topic to Focus 

- Over the next three days, I will focus on completing the pending LMV video for Day 13 and conducting a thorough, quick revision of the entire Linux coursework.
---
