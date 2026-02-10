#!/bin/bash
if [[ $# -eq 0 ]]
then
	ARGS="No Arguments Provided"
else
	ARGS=$@
fi

echo "Total number of arguments: $#"
echo "Script Name: $0"
echo "Arguments: $ARGS"
