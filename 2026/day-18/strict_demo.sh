#!/bin/bash
set -euo pipefail

# 1. Undefined variable test (set -u)
echo "Trying to use an undefined variable..."
echo "$UNDEFINED_VAR"   # This will cause the script to exit immediately

# 2. Command failure test (set -e)
echo "Trying a failing command..."
ls /var/tmp/test   # This will cause the script to exit immediately

# 3. Pipe failure test (set -o pipefail)
echo "Trying a failing pipe..."
false | grep something      # With pipefail, the script exits because 'false' fails
