#!/bin/bash
ID=$(id -u $(whoami))
if [[ $ID != 0 ]]
then
	echo "WARNING!! This script requires root priviledge.."
	exit 1
fi

packages=("nginx" "curl" "wget")

for package in ${packages[@]}
do
	echo "Checking for: $package.."
	sleep 1
	rpm -q $package 2>&1 > /dev/null
	STATUS=`echo $?`
	if [[ $STATUS -eq 0 ]]
	then
		echo "$package is already installed.. Skipping..!!"
	else
		echo "Installing $package.."
		dnf install $package -y 
	fi

done
