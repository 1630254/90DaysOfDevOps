#!/bin/bash
set -euo pipefail

# Function to print hostname and OS info
print_system_info() {
    echo "===== System Info ====="
    echo "Hostname: $(hostname)"
    echo "OS Info:"
    uname -a
    echo
}

# Function to print uptime
print_uptime() {
    echo "===== Uptime ====="
    uptime
    echo
}

# Function to print disk usage (top 5 by size)
print_disk_usage() {
    echo "===== Disk Usage (Top 5) ====="
    df -h | sort -k2 -h -r | head -n 5
    echo
}

# Function to print memory usage
print_memory_usage() {
    echo "===== Memory Usage ====="
    free -h
    echo
}

# Function to print top 5 CPU-consuming processes
print_top_cpu_processes() {
    echo "===== Top 5 CPU-consuming Processes ====="
    ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
    echo
}

# Main function to call all others
main() {
    print_system_info
    print_uptime
    print_disk_usage
    print_memory_usage
    print_top_cpu_processes
}

# Run main
main
