#!/bin/bash

read -p "Enter the service name to check .." SERVICE

read -p "Do you want to check the status? (y/n)" ANSWER

ANSWER=$(echo "$ANSWER" | tr '[:upper:]' '[:lower:]')

if [[ "$ANSWER" == "y" ]]
then
	STATUS=`systemctl status $SERVICE | grep Active | awk '{print $2, $3}'`
	echo $STATUS

elif [[ $ANSWER == "n" ]]
then
	echo "Skipped"
else
	echo "Enter a valid response"
fi

