# Linux Troubleshooting Runbook

## Target Service / Process
- **Service:** docker (Docker Engine Daemon)
- **PID:** Retrieved via `systemctl status docker` or `pidof dockerd`

---

## Environment Basics

`uname -a`
- **Output:** `Linux fedora 6.14.5-100.fc40.x86_64 #1 SMP PREEMPT_DYNAMIC Fri May  2 14:22:13 UTC 2025 x86_64 GNU/Linux`
- **Note:** Kernel version is `6.14.5-100.fc40.x86_64` and Architecture `x86_64` confirmed.

`cat /etc/os-release`
- **Output:** `Fedora Linux 40 (Workstation Edition)`
- **Note:** OS release verified.

---

## Filesystem Sanity

`mkdir /tmp/runbook-demo`
`cp /etc/hosts /tmp/runbook-demo/hosts-copy && ls -l /tmp/runbook-demo`
- **Output:** Able to  successfully copy `hosts-copy`
- **Note:** Filesystem is writable and permissions are normal.

---

## Snapshot: CPU & Memory

`ps -o pid,pcpu,pmem,comm -p $(pidof dockerd)`
- **Output:** **PID:** 157563, ***%CPU:** 0.0, **%MEM:** 0.6, **Process Name:** dockerd
- **Note:** Idle/Dormant — The Docker daemon is active but currently "parked," consuming negligible system resources.

`free -h`
- **Output:** **total:** 7.7Gi, **used:** 5.9Gi, **free:** 194Mi, **shared:** 211Mi, **buff/cache:** 2.1Gi, **available:** 1.81Gi
- **Note:** Critical Memory Saturation — The guest is physically exhausted and vulnerable to hypervisor-level performance collapse.

---

## Snapshot: Disk & IO

`df -h`
- **Output:** /devsda3 39G total, 12G used, 30G free
- **Note:** Optimal Storage Health — Significant headroom available with no immediate risk of volume exhaustion.

`sudo du -sh /var/lib/docker`
- **Output:** 176K    /var/lib/docker
- **Note:** Dormant / Empty — The Docker daemon is currently a "ghost town" with zero active containers, images, or volumes stored in the default path.

`iostat`
- **Output:** CPU idle > 88%, IOwait = 0.04%, steal =0.00%
- **Note:** System is under-utilized, there is no "Steal" time (0.00%), which means if this is a virtual machine

---

## Snapshot: Network

`ss -tulpn | grep dockerd`
- **Output:** No output
- **Note:** The Docker daemon is running locally but is not listening on any network ports.

`curl --unix-socket /var/run/docker.sock http://localhost/_ping`
- **Output:** No ouput
- **Note:** the docker daemon will use the unix socket unix:///var/run/docker.sock. It's recommended to keep this setting for security reasons.

---

## Logs Reviewed

`journactl -u docker -n 50`
- **Output:** Normal startup messages, no recent errors
- **Note:** Docker is fully operational but running in a "Vanilla" configuration with several storage and tracing plugins skipped.

`sudo tail -n 50 /var/log/doacker.log`
- **Output:** No such file or directory
- **Note:**: Fedora 40 uses systemd, which means it doesn't write Docker logs to a plain text file like `var/log/docker.log` Instead, it sends them to the systemd journal.

---

## Quick Findings

- **CPU & Memory:** CPU is idling comfortably, but RAM is saturated with only 1.8Gi available and heavy reliance on 2.8Gi of zram (swap).
- **Docker Daemon Status:** The engine is Active (Running) but Disabled on boot, currently consuming very low RAM with zero active containers.
- **Disk Utilization:** The system is Storage-Healthy, while the Docker directory is a empty.
- **Network Listening:** No network ports are open for Docker; the daemon is isolated and listening exclusively on the local Unix socket (/run/docker.sock).
- **Journal Log Analysis:** Logs show no errors or warnings.

---

## If This Worsens (Next Steps)

- **Restart Strategy:** Restart Docker (`systemctl restart docker`) and check container health.
- **Increase Log Verbosity:** Run `dockerd --debug` or adjust logging in `/etc/docker/daemon.json`
- **Collect Diagnostics:** Use `docker info`, `docker stats`, and `strace -p <pid>` for deeper analysis.

---
