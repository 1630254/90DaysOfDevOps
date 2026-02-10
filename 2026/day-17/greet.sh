#!/bin/bash

if [[ $# -eq 0 ]]
then 
	echo "Usage: $0 <name>"
	exit 1
fi

NAME=$1
echo "Hello $1..!!"
