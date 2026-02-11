#!/bin/bash

#Function to greet  
funcGreet () {
	name=$1
	echo "Hello, $name...!!"
}

# Function to add two numbers
funcAdd () {
	num1=$1
	num2=$2
	result=$((num1 + num2))
	echo "Sum of two numbers are: $result"
}

#Calling functions
funcGreet Manas 
funcAdd 4 6


