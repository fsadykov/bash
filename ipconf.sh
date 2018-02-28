#!/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
file=/etc/sysconfig/network-scripts/ifcfg-$(ifconfig | awk -F":" '{print $1}' | awk '{print $1}' | head -n1) 
OSS=$(cat /etc/redhat-release | grep -oh '7\|6' | head -n1| grep -v ^$)

functiondhcp(){
sed '/IPADDR/d' -i $file
sed '/GATEWAY/d' -i $file
sed '/NETMASK/d' -i $file
sed '/DNS/d' -i $file
sed '/HWADDR/d' -i $file
sed 's/static/dhcp/g' -i $file
}

functionstatic(){
read -p "${red}Please enter the ip :${reset}" ipaddr
read -p "${red}Please enter the gateway :${reset}" gateway
read -p "Please enter the netmask :" netmask
echo "IPADDR=$ipaddr" >> $file
echo "GATEWAY=$gateway" >> $file
echo "NETMASK=$netmask" >> $file
echo "DNS1=8.8.8.8" >> $file
echo "DNS2=8.8.4.4" >> $file
sed '/HWADDR/d' -i $file
sed 's/dhcp/static/g' -i $file > /dev/null
sed 's/ONBOOT=no/ONBOOT=yes/g' -i $file > /dev/null
}

functionrestart(){
read -p "Do you want to restart network yes or no? :" restartuser
if [ $restartuser == "yes" ] || [ $restartuser == "Yes" ] || [ $restartuser == "YES" ]
then
	service network restart

fi
}

functioncheck(){
if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
	echo "${green}#################################################"
	ping -c 4 8.8.8.8 | head -n4 
	echo "You network is good"${reset}
else
	echo "${red}Your network is down"
	echo "Make sure you added network adapter"
	read -p "Press${reset} ${green}enter${reset}${red} to continue${reset}"
	dhclient
	ping -c 4 8.8.8.8 | head -n4
	exit 1
fi
}

functionrestartc(){
while true
do
read -p "Do you want to restart your network ${green}yes${reset} or ${red}no${reset}? :" restartuser
if [ $restartuser == "yes" ] || [ $restartuser == "Yes" ] || [ $restartuser == "YES" ]
then
        systemctl restart network
      	break
elif [ $restartuser == "no" ] ||[ $restartuser == "No" ] || [ $restartuser == "NO" ]
then
	break 
else 
	echo "${red}You choosed wrong option${reset}"
	sleep 0.9
	clear
fi
done
}

functionstaticc(){
read -p "${red}Please enter the ip :${reset}" ipaddr
read -p "${red}Please enter the gateway :${reset}" gateway
read -p "Please enter the netmask :" netmask
echo "IPADDR=$ipaddr" >> $file
echo "GATEWAY=$gateway" >> $file
echo "NETMASK=$netmask" >> $file
echo "DNS1=8.8.8.8" >> $file
echo "DNS2=8.8.4.4" >> $file
sed 's/dhcp/static/g' -i $file 
sed '/HWADDR/d' -i $file
sed 's/ONBOOT="no"/ONBOOT="yes"/g' -i $file  
sed 's/ONBOOT=no/ONBOOT=yes/g' -i $file 
}



while true
do	
	clear 
	echo "${green}############################################${reset}"
	echo " ${green}Welcome to Farkhod Sadykov's script ${reset} "
	echo "${green}############################################${reset}"
	echo "1. Centos 6"
	echo "2. Centos 7"
	echo "3. Quit"
	read -p "Please choose options :" OS
	if [ $OS == "1" ] && [ $OSS == "6" ]
	then
		echo "${green}############################################${reset}"
		echo "${green}1. DHCP "
		echo "2. STATIC${reset}"
		echo "${red}3. Back ${reset}"
		read -p "Chose options :" ip
		if [ $ip == "1" ]
		then
			functiondhcp
			cat $file
			functionrestart
			functioncheck
			exit 1
		elif [ $ip == "2" ]
		then	
			functiondhcp
			functionstatic
			cat $file
			functionrestart
			functioncheck
			sleep 0.9
			exit 1
		elif [ $ip == "3" ]
		then
			break 1
		else 
			echo "${red}You chose wrong options please choose option above${reset}"
			sleep 0.9
		fi
	elif [ $OS == "2" ] && [ $OSS == "7" ]
	then
		echo "${green}############################################${reset}"
                echo "${green}1. DHCP "
                echo "2. STATIC${reset}"
                echo "${red}3. Back ${reset}"
                read -p "Chose options :" ips
		if [ $ips == "1" ]
		then
			functiondhcp
			cat $file
			functionrestartc
			functioncheck
			exit 1
		elif [ $ips == "2" ]
		then
			functiondhcp
			functionstaticc
			cat $file
			functionrestartc
			functioncheck
			exit 1 
		elif [ $ips == "3" ]
		then
			echo " "
			break 1
		else 
			echo "${red}You chose wrong options please choose option above${reset}"
			sleep 0.9 
		fi
	elif [ $OS == "3" ]
	then
		echo "${green}Thanks for using my script:)${reset}"
		exit 1
	else
		echo "${red}You chosed wrong options or choosed wrong Version Centos ${reset}"
		sleep 0.9
	fi 
done


# author Farkhod Sadykov
