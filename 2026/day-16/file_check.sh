#!/bin/bash
read -p "Enter the full path name for the file to check: " FILE

if [[ -f $FILE ]]
then 
	echo "File $FILE: exists"
else
	echo "File $FILE: Error Not Found!!"

fi
