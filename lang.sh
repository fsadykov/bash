#!/bin/bash

echo "What language do you speak ? "
echo "1 - English"
echo "2 - Spanish"
echo "3 - Russian"
read -p "what language do you speak? " lang
if [ $lang -eq 1 ]
then 
	echo "Hi"
elif [ $lang -eq 2 ]
then 
	echo "Halo"
elif [ $lang -eq 3 ]
then 
	echo "Privet"
fi

