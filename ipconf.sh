#!/bin/bash
 
checkip=$(grep IPADDR /etc/sysconfig/network-scripts/ip | awk -F= '{print $1}'
)

chnatmask=$(grep NETMASK /etc/sysconfig/network-scripts/ip | awk -F= '{print $1}'
 )
if [ "$checkip" == "IPADDR" ] 
then 
	echo yes 
else 
	read -p "Please enter your ip: " ipconf
	read -p "Please enter your GATEWAY: " gateway
	read -p "Please enter your DNS: " DNS
	echo IPADDR=$ipconf >> /etc/sysconfig/network-scripts/ip
	echo NETMASK=255.255.225.0 >> /etc/sysconfig/network-scripts/ip
	echo GATEWAY=$gateway >> /etc/sysconfig/network-scripts/ip
	echo DNS1$DNS >> /etc/sysconfig/network-scripts/ip
	echo DNS2=8.8.8.8 >> /etc/sysconfig/network-scripts/ip
fi
service network restart
