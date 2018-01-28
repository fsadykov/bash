#!/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
file=/etc/sysconfig/network-scripts/ifcfg-eth0 
#file=/home/template



functiondhcp(){
echo "$(grep -v "IP" $file)" > $file
echo "$(grep -v "NETMASK" $file)" > $file
echo "$(grep -v "GATEWAY" $file)" > $file
echo "$(grep -v "DNS" $file)" > $file
sed 's/BOOTPROTO=static/BOOTPROTO=dhcp/g' -i $file
}





functionstatic(){
read -p "${red}Please enter the ipaddress :${reset}" ipaddr
read -p "${red}Please enter the gateway :${reset}" gateway
#read -p "Please enter the netmask :" netmask
netmask=255.255.255.0
echo "IPADDR=$ipaddr" >> $file
echo "GATEWAY=$gateway" >> $file
echo "NETMASK=$netmask" >> $file
echo "DNS1=8.8.8.8" >> $file
echo "DNS2=8.8.4.4" >> $file
sed 's/BOOTPROTO=dhcp/BOOTPROTO=static/g' -i $file
sed 's/ONBOOT=no/ONBOOT=yes/g' -i $file
}

functionrestart(){
read -p "Do you want to restart network yes or no? :" restartuser
if [ $restartuser == "yes" ] || [ $restartuser == "Yes" ] || [ $restartuser == "YES" ]
then
	service network restart
fi


}

functioncheck(){
echo "${green}######################################################"
echo "# You install static IP"
ping -c 4 8.8.8.8
echo "######################################################"${reset}
}







echo " ${green}Welcome to Farkhod Sadykov's script ${reset} "

echo "1. Centos 6"
echo "2. Centos 7"
read -p "What is your versioning vs kernel version? :" OS
if [ $OS == "1" ]
then
	echo "${green}############################################${reset}"
	echo "${green}1. DHCP "
	echo "2. STATIC${reset}"
	echo "${red}3. quit ${reset}"
	read -p "Chose options :" ip
	if [ $ip == "1" ]
	then
		functiondhcp
	elif [ $ip == "2" ]
	then	
		functiondhcp
		functionstatic
		functionrestart
		functioncheck
	fi






	
elif [ $OS == "2" ]
then
	echo "Centos 7"
fi 

