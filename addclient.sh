#!/bin/bash
#This line is messages for user
echo -en "In order to continue please add 'ansible' user to remote system\n"
echo -en "Also, please make sure ansible user in /etc/sudoers file with full privileges \n"
echo ""
echo -en "Please run the following command on remote system as root\n"
echo ""
echo -en "[root@localhost]# visudo\n"
echo ""
echo -en "Go to the line 99 and add the following\n "
echo ""
echo -en "ansible    ALL=(ALL)     NOPASSWD:   ALL"

echo ""
echo ""
echo ""
echo ""

#This line prompts user if they added user
echo -en "Have you added ansible user to remote system? yes/no "
read ANSWER

#This line checks for user input if user said yes it will move on otherwise it will quit
if [ $ANSWER == "yes"  ]
then
	:
else
	echo ""
	echo -en "Please add ansible user to remote system and come back\n"
	echo -en "Thank you\n"
	echo ""
	exit 1
	
fi

#This line asks for hostname of remote system
echo -en "Please enter your hostname: "
read HOSTNAME1


if [ -f $HOSTNAME1 ]
then
	echo "The hostname exists"
	exit 1 
fi


#This line asks for customer id 
echo -n "What is the customer ID?: " 
read FOLDER
if [ -d $FOLDER  ]
then
	
	:
	echo ""
	echo "Folder exists moving on..."
	echo ""
else
	#This line creates a folder in objects/servers folder 
	mkdir /usr/local/nagios/etc/objects/servers/$FOLDER
	echo ""
	echo "##################################"
	echo "Creating a new folder for customer" 
	echo "##################################"
	echo ""
fi
# this line copies template to newclient
cp -rf /usr/local/nagios/etc/objects/servers/template /usr/local/nagios/etc/objects/servers/$FOLDER/$HOSTNAME1.cfg

echo -n "What is the IP? "
read IP
echo -n "What is the SSH Port?: "
read PORT


echo -en "Please enter root  passwd for remote system once: "
read ROOTPASSWD


#This line checks if the remote host is up. 

cd /usr/local/nagios/etc/objects/servers &> /dev/null
sed "s/172.16.0.23/$IP/g" /usr/local/nagios/etc/objects/servers/$FOLDER/$HOSTNAME1.cfg -i
cd /usr/local/nagios/etc/objects/servers/$FOLDER
sed "s/client1/$HOSTNAME1/g" /usr/local/nagios/etc/objects/servers/$FOLDER/$HOSTNAME1.cfg -i
cd - &> /dev/null

MESSAGE=$(fping $IP | awk '{print $3}' )
if [ $MESSAGE == "alive" ]
then	
	echo "The host is alive\n"
	sleep 2
	echo "moving on" 
else
	echo "The host seems to be down\n"
	echo "Please make sure the host is up\n"
	sleep 3
	echo 1
fi
sshpass -p $ROOTPASSWD ssh-copy-id "root@$IP -p $PORT" &> /dev/null



#This line is for ansible only
#This line creates an inventory file for ansible 
echo $IP:$PORT > /etc/ansible/$IP
chmod +x /etc/ansible/$IP
echo -en "Please wait nrpe is being installed"
ansible-playbook -i /etc/ansible/$IP  /etc/ansible/nrpe_install.yml

echo ""
echo "The host successfully added please check nagios web page"
echo ""
echo -en "Would you like to add another host yes/no? :"
read ANSWER

if [ $ANSWER == "yes" ]
then
	exit 0
else
	echo "It was pleasure working with you\n"
	echo "Even though I am a machine\n"
	echo Bye
	exit 1
fi



echo "Please enter CTRL +C to quit"
echo "################################################"
echo ""
bash addclient.sh
