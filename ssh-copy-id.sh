#!/bin/bash
# In this line if gave collor for my script output
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`


# In this line will print Welcome words
echo "${green}##########################################${reset}"
echo "${green}###### ansible add client script #########${reset}"
echo "${green}##########################################${reset}"
read -p "${green}Please enter the IP:${reset} " IP
read -p "Please enter the passwd of remote VM: " PASSWD

# This line will create ansible client on remote VM
echo -e "
useradd ansible | echo redhat | passwd --stdin ansible
echo "'"ansible  ALL=(ALL)       NOPASSWD: ALL"'" >> /etc/sudoers
" > template.sh

# This line copies ssh-copy-id to remote VM
sshpass -p "$PASSWD" ssh-copy-id -o StrictHostKeyChecking=no root@$IP &> /dev/null
sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no root@$IP 'bash -s' < template.sh


# This line will chech remote VM for exist user ansible
RESULT=$(sshpass -p "$PASSWD" ssh -o StrictHostKeyChecking=no root@$IP "cat /etc/sudoers| grep ansible | awk '{print $1}'")
echo $RESULT > result1
RS=$(cat result1 | awk '{print $1}')
if [ $RS == "ansible" ] 2>/dev/null
then
	echo "${green}ansible user is added in your remote VM${reset}"
else
	echo "${red}ansible user is not added in your remote vm${reset}"
fi


# this line will delete template files
rm -rf template.sh
