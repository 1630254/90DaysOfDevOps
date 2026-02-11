#!/bin/bash

# Function to check available disk space
check_disk() {
    AVAILABLE_SPACE=$(df -h | awk 'NR==2 {print $4}')
    echo "$AVAILABLE_SPACE"
}

# Function to check available memory
check_memory() {
    AVAILABLE_MEMORY=$(free -h | awk 'NR==2 {print $7}')
    echo "$AVAILABLE_MEMORY"
}

# Calling functions
FREE_SPACE=$(check_disk)
echo "Available Space in / partition is: $FREE_SPACE"

FREE_MEMORY=$(check_memory)
echo "Available Free Memory is: $FREE_MEMORY"
