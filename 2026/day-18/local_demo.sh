#!/bin/bash

# Function with local variable
local_demo() {
    local var="Local variable"
    echo "Inside local_demo: $var"
}

# Function with global variable
global_demo() {
    var="Global variable"
    echo "Inside global_demo: $var"
}

echo "=== Local Demo ==="
local_demo
echo "Outside after local_demo: ${var:-var is undefined}"

echo
echo "=== Global Demo ==="
global_demo
echo "Outside after global_demo: $var"
