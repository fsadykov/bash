#!/bin/bash

read -p "Please enter how much money you have? " budget
if [ $budget -lt 1000 ] 
then
	echo "Sorry we dont have a car for $budget"
	echo "Do you want a bike or scooter?"
	echo "1 - Scooter"
	echo "2 - Bike"
	read -p "> " product
	if [ $product eq 1 ]
	then
		echo "Here is your Scooter"
	elif [ $product -eq 2 ]
	then
		echo "Here is your bike"
	fi 
	 
elif [ $budget -lt 20000 ]
then 
	echo "please checkout these user cars"
elif [ $budget -lt 30000 ]
then 
	echo "Please checkout these brand new Toyotas"
elif [ $budget -lt 50000 ]
then
	echo "Please checkout these Cadilacs"
else
	echo "please checkout these Benteyls"
fi
