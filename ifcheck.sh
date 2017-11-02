#!/bin/bash 

a=2
b=4

if [ $a == "2" ]
then 
	echo yes
	if [ $b == "22" ]
	then 
		echo correct
	else
		echo it is not true 
	fi
fi
