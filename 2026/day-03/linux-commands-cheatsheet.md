# 20 Basic Linux Commands (Process, File System, Networking)

## Process Management
1. `ps aux` → Show all running processes with details.  
2. `ps -ef` → Display processes in full-format listing.  
3. `ps -u <username>` → Show processes owned by a specific user.  
4. `ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu` → List processes sorted by CPU usage.  
5. `top` → Display real-time system processes and resource usage.  
6. `kill -9 <PID>` → Forcefully terminate a process by its ID.  

---

## File System
7. `ls -l` → List files in long format with permissions.  
8. `pwd` → Print the current working directory.  
9. `cd /path` → Change directory to the specified path.  
10. `mkdir newdir` → Create a new directory.  
11. `rm -rf dir` → Remove a directory and its contents recursively.  
12. `cp file1 file2` → Copy a file to another location.  
13. `mv file1 file2` → Move or rename a file.  
14. `find / -name file.txt` → Search for a file by name.  
15. `du -sh` → Show disk usage of the current directory in human-readable format.  
16. `df -h` → Display available disk space in human-readable format.  
17. `cat file.txt` → View the contents of a file.  
18. `touch newfile.txt` → Create an empty file or update its timestamp.  

---

## Networking Troubleshooting
19. `ping google.com` → Test connectivity to a host.  
20. `ifconfig` → Show or configure network interfaces.  
21. `ip addr show` → Display IP addresses assigned to interfaces.  
22. `netstat -tulnp` → Show active network connections and listening ports.  
23. `traceroute google.com` → Trace the route packets take to a destination.  

---