#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status


mkdir /tmp/devops-test > /dev/null 2>&1 || echo "Error: Could not create directory (maybe it already exists)"
cd /tmp/devops-test || echo "Error: Could not navigate into directory"
touch testfile.txt || echo "Error: Could not create file"

echo "Script executed successfully!"


