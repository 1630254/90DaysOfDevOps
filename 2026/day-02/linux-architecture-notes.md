# Linux Basics: Core Components & Process Management

## Introduction to Linux

- Linux is a free, open-source OS inspired by Unix.
- Created by Linus Torvalds; powerful, multi-user, multitasking.
- Linux distributions bundle kernel, system software, libraries, and apps.
- Popular Distributions -  Ubuntu, RHEL,CentOS, Linux Mint etc.
- Known for stability, flexibility, and wide use across servers, desktops, and embedded systems.

---

## 1. Linux System Architecture: The ASK Model

The Linux operating system architecture is structured in a layered, **"ASK" model (Applications-Shell-Kernel)**. This design separates user interactions from direct hardware manipulation to ensure system stability and security.

### Breakdown of the ASK Model
The architecture follows a hierarchy from the highest layer (user interaction) to the lowest (hardware).

* **Applications (User Space)**: Software programs that users interact with directly e.g. Web browsers, office suites, database software, or GUI tools.

* **Shell & System Libraries**: Acts as a command-line interpreter (e.g., `sh`,`bash`, `ksh`,`zsh`) that translates user commands into instructions the kernel can understand.
System Libraries are  Predefined functions (like the GNU C library, `glibc`) that applications use to make system calls.

* **Kernel (Kernel Space)**: The core of the operating system, which runs in "kernel space" and has direct access to the hardware.
Responsible for managing system resources including CPU scheduling, memory allocation etc.


### The Underlying Foundation: Hardware

Below the Kernel is the **Hardware Layer**, which consists of the physical components of the computer:
* **CPU** (Central Processing Unit)
* **RAM** (Random Access Memory)
* **Hard Drives / SSDs**

The kernel acts as the **mediator** between this hardware and the user applications.

---

### How the ASK Model Works Together (Request Flow)

When a task is performed, the request flows through the layers as follows:

1. **User** interacts with an **Application** (e.g., clicks "save" in a text editor).
2. **Application** calls a function in the **System Library** (e.g., `write()`).
3. **System Library** makes a **System Call** to the **Kernel**.
4. **Kernel** verifies permissions and tells the **Hardware** (Hard Drive) to take action.

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