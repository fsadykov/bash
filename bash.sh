#!/bin/bash

echo "Please enter on of below option"
echo "1 - North"
echo "2 - South"
read -p "> " direction

read -p "Please enter address number: " number

#echo "$direction $number "

if [ $direction -eq 1 ]
then 
	echo "You live at North side"
elif [ $direction -eq 2 ]

then 
	echo "You live at South side"
eclse
	echo "Error! Please chose 1 for North and 2 for South"
fi 
