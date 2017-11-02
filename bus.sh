#!/bin/bash

read -p "How many people need a ride ? " number 

while [ $number -gt 0 ]
do
	
	if [ $number -le 4 ]
	then 
		echo "Where are sending you a car "
		number=$((number - 4 )) 
	elif [ $number -le 10 ]
	then	
		echo "We are sending you a van"
		number=$((number - 10 )) 
	#elif [ $number -le 30 ]
	#then 
	else
		echo "We are sendeing you a bus"
		number=$((number - 30 )) 
	fi
done
