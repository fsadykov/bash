#!/bin/bash



read -p "Hi, What is your name: " customer
if [ $customer == "Farkhod" ]
then
	echo "Hi $customer"
else 
	echo "Get out!!!"
fi  
