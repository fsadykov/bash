#!/usr/bin/env bash

# Make sure listuser file has content first column user second is user size

for user in $(cat listuser.txt | awk '{print $1}'):
do
   size=$(grep  $user listuser.txt | awk '{print $2}')
   # Change echo to your command isi quot
   # to test error change comand give syntax error comand for example  "is quote  $user $size"
   # Should show  User error check  and Useranem
   isi quata quatas create --path /ifs/cifs/-data/HDrive/$user --type directory --hard-treshhold 10GB --advisory-treshhold --containers=yes $size > /dev/null && echo "User "$user" has been added succesefuly" || echo "User error check:" $user
done
