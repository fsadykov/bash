#!/bin/bash

read -p  "what is the season? " x

if [ "$x" == "winter" ]
then	
	echo "please take coat"
elif [ "$x" == "spring" ]
then
	echo "Please take shirt"
elif [ "$x" == "summer" ]
then 
	echo "Please take slipper"
elif [ "$x" == "fall" ]
then 
	echo "please take umberela"
fi


