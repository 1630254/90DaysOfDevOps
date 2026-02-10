#!/bin/bash

read -p "Please input a number: " NUMBER

if [[ $NUMBER -eq 0 ]]
then
	echo "Number is zero"
elif [[ $NUMBER -gt 0 ]]
then
	echo "Number is greater than zero.."

elif [[ $NUMBER -lt 0 ]]
then 
	echo "Number is less than zero.."
fi
