#!/bin/bash 
pass="redhat"
user="admin"
host="10.0.100.104"
sshpass -p $pass scp /My_scripts/ftp/file.txt  $user@$host:/var/ftp/pub/ 
