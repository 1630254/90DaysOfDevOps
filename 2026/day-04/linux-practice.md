# Linux Process Management & Troubleshooting Guide (Fedora 40)

## 1. Checking Running Processes
Monitoring processes is essential for identifying resource consumption, process ownership, and managing system health via Process IDs (PIDs).

### Key Concepts
* **Listing:** Seeing all active tasks.
* **Ownership:** Identifying which user started a process.
* **Resources:** Monitoring CPU and Memory consumption.
* **Management:** Using PIDs to kill, restart, or monitor specific tasks.

### Static View: `ps`
The `ps` command provides a snapshot of current processes. In Fedora/RHEL, the BSD-style `aux` is standard.
* `ps aux`: Lists all processes system-wide with CPU/MEM usage.
* `ps -ef`: Lists all processes with full command details and Parent PIDs (PPIDs).
* **Top 10 Memory Users:**
*   `ps aux --sort=-%mem | head -n 11`

**Common Filters:**
* `ps aux | grep sshd`: Find the SSH daemon process.
* `ps aux | grep python`: Find all running Python scripts.

### Dynamic View: `top`
The `top` command provides a real-time, interactive dashboard of system activity.
* `top`: Default dynamic view.
* `top -o %CPU`: Sorts the live list by CPU usage.
* `top -o %MEM`: Sorts the live list by Memory usage.

---

## 2. Inspecting Systemd Services
On Fedora 40, `systemd` is the service manager. Use `systemctl` to inspect service health and configuration.

| Command | Purpose |
| :--- | :--- |
| `systemctl status <service>` | Check if the service is active, inactive, or failed. |
| `journalctl -u <service>` | View the specific logs/errors for that service. |
| `systemctl cat <service>` | View the underlying unit file and configuration. |
| `systemctl list-dependencies <service>` | See what other services this unit relies on. |

---

## 3. Mini Troubleshooting: SSH Connectivity
If you cannot connect to the local SSH server from a remote host, follow this structured workflow.

### Step 1: Check if the process is running
`ps -ef | grep sshd`  
- Look for sshd entries.
- If missing → the daemon isn’t running.

### 2. Check service status
`systemctl status sshd.service`
- Is it active (running) or failed?
- If failed, note the error message.

### 3. Inspect logs
`journalctl -u sshd.service -n 50`
- Review the last 50 log entries.
- Common issues: port conflicts, bad configuration, missing host keys

### 4. Verify configuration
`sshd -t -f /etc/ssh/sshd_config`
- Tests the SSH daemon configuration.
- If errors appear, fix /etc/ssh/sshd_config.

### 5. Check port availability
`ss -tulnp | grep sshd`
- Ensure sshd is listening on port 22 (or custom port).
- Example: 0.0.0.0:22 or <ip_address>:22.
- Conflicts may prevent binding.

### 6. Restart the service
`systemctl restart sshd.service`
`systemctl status sshd.service`
- Restart and confirm the service is running.

### 7. Validate connectivity
From a remote client machine:
`ssh user@hostname`
- If connection fails, check firewall rules:
`sudo firewall-cmd --zone=public --query-service=ssh`

---

