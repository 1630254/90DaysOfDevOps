# Linux Basics: Core Components & Process Management

## Introduction to Linux

- Linux is a free, open-source OS inspired by Unix.
- Created by Linus Torvalds; powerful, multi-user, multitasking.
- Linux distributions bundle kernel, system software, libraries, and apps.
- Popular Distributions -  Ubuntu, RHEL,CentOS, Linux Mint etc.
- Known for stability, flexibility, and wide use across servers, desktops, and embedded systems.

---

## 1. Core Components

- **Kernel:** Core, managing hardware and system calls.
- **User Space:** Runs apps, shells, utilities; isolated from kernel.
- **Init/systemd:** First process (PID 1), starts services, manages dependencies, handles logging.

---

## 2. systemd Overview

- Boots system faster by parallel service start.
- Manages services as units with dependencies.
- Centralized logging with journalctl.
- Key tools: systemctl, journalctl, systemd-analyze, udev.
- Targets: multi-user.target (text login), graphical.target (desktop).

---

## 3. Process Management

- Processes have unique PIDs.
- Run in foreground (fg) or background (bg).
- Monitored with ps, top.
- Lifecycle states: Running (R), Interruptible Sleep (S), Uninterruptible Sleep (D), Stopped (T), Zombie (Z).

---

## 4. Signals

- Control processes via signals.
- Common signals: SIGTERM (15), SIGKILL (9), SIGINT (2), SIGSTOP (20), SIGCONT (18).
- Use kill command to send signals.

---

## 5. Daily Commands

- ls: for listing files and directories, 
- cd: to change directory 
- ps: to check running processes
- top: to check processes dynamically
- man: helps to get details about a function

---

✅ Clear Linux overview, components, process lifecycle, and signals.