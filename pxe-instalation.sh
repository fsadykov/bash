#!/bin/bash
#!/bin/bash
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`


functioninstall(){
yum install  syslinux  net-tools -y > /dev/null
}


functionruls(){
# Port 21 53 67 for TFTP and for ProxyDHCP
firewall-cmd --add-service=ftp --permanent 2> /dev/null
firewall-cmd --add-service=dns --permanent 2> /dev/null
firewall-cmd --add-service=dhcp --permanent 2> /dev/null
firewall-cmd --add-port=69/udp --permanent 2> /dev/null
firewall-cmd --add-port=4011/udp --permanent 2> /dev/null
firewall-cmd --reload 2> /dev/null
}


functionstart(){
systemctl start dnsmasq
systemctl start vsftpd
systemctl enable dnsmasq > /dev/null
systemctl enable vsftpd > /dev/null
}

functionpxeboot(){
echo -e "
default menu.c32
prompt 0
timeout 300
ONTIMEOUT local
menu title ########## PXE Boot Menu ##########
label 1
menu label ^1) Install CentOS 7 x64 with Local Repo
kernel centos7/vmlinuz
append initrd=centos7/initrd.img method=ftp://$IP/pub devfs=nomount
label 2
menu label ^2) Install CentOS 7 x64 with http://mirror.centos.org Repo
kernel centos7/vmlinuz
append initrd=centos7/initrd.img method=http://mirror.centos.org/centos/7/os/x86_64/ devfs=nomount ip=dhcp
label 3
menu label ^3) Install CentOS 7 x64 with Local Repo using VNC
kernel centos7/vmlinuz
append  initrd=centos7/initrd.img method=ftp://$IP/pub devfs=nomount inst.vnc inst.vncpassword=password
label 4
menu label ^4) Boot from local drive
" > /var/lib/tftpboot/pxelinux.cfg/default
}





functionconf(){
echo -e "
interface=$IF,lo
domain=centos7.lan
dhcp-range= $IF,$STARTIP,$ENDIP,255.255.255.0,1h
dhcp-boot=pxelinux.0,pxeserver,$IP
dhcp-option=3,$DHCPG
dhcp-option=6,92.168.1.1, 8.8.8.8
server=8.8.4.4
dhcp-option=28,10.0.0.255
dhcp-option=42,0.0.0.0
pxe-prompt="Press F8 for menu.", 60
pxe-service=x86PC, "Install CentOS 7 from network server $IP", pxelinux
enable-tftp
tftp-root=/var/lib/tftpboot " > /etc/dnsmasq.conf
}



echo "${green}###########################################################################${reset}"
echo "${green}************************* PXE SERVER Installation *************************${reset}"
echo ""
echo "${green}Please following the instructions for install PXE server${reset}"
echo "${red}Please before the run this script attach ISO Image${reset}"
echo ""
IF=$(ifconfig | awk -F":" '{print $1}' | head -n 1)
IP=$(ip addr | grep 'state UP' -A2 | tail -n1 | awk '{print $2}' | cut -f1  -d'/')
echo "Example ${green}192.168.2.3${reset}, 192.168.2.255"
read -p "Please enter range ip for DHCP: " STARTIP
echo "Example $STARTIP, ${green}192.168.2.253${reset}"
read -p "Please give end of the range: " ENDIP
read -p "Please give gateway for DHCP: " DHCPG





dnsmasq=$(rpm -qa | grep dnsmasq | cut -c1-7 )
if [ $dnsmasq == "dnsmasq" ]
then
	echo "${green}You already have installed dnsmasq${reset}"
else
	echo "${red}Installing dnsmasq${reset}"
	yum install dnsmasq -y
	functionconf
fi

syslinux=$(rpm -qa | grep syslinux | cut -c1-8)
if [ $syslinux == "syslinux" ]
then
	echo "${green}You already have installed tftp-server${reset}"
else
	echo "${red} Installing tftp-server ${reset}"
	yum install syslinux -y
fi


server=$(rpm -qa | grep tftp-server | cut -c1-10)
if [ $server == "tftp-serve" ]
then
	echo "${green}You already have installed tftp-server${reset}"
else
	echo "${red} Installing tftp-server ${reset}"
        yum install tftp-server -y
	cp -r /usr/share/syslinux/* /var/lib/tftpboot 2> /dev/null
	mkdir /var/lib/tftpboot/pxelinux.cfg
	touch /var/lib/tftpboot/pxelinux.cfg/default
	functionpxeboot
fi


vsftpd=$(rpm -qa | grep vsftpd | cut -c1-6 )
if [ $vsftpd == "vsftpd" ]
then
	echo "${green}You already have installed vsftpd${reset}"
else
	echo "${red}Installing vsftpd${reset}"
	yum install vsftpd -y
	functionruls
	echo "${green}You have to atach iso image ${reset}"
	read -p "${green}Please chose the options 1: for download online 2: manual mount for skip this option press any key " answer
	if [ $answer == "1" ]
	then
		echo "works 1"
		wget http://centos.unixheads.org/7/isos/x86_64/CentOS-7-x86_64-DVD-1708.iso
		mount -o loop CentOS-7-x86_64-DVD-1708.iso  /mnt
		mkdir /var/lib/tftpboot/centos7
		cp /mnt/images/pxeboot/vmlinuz  /var/lib/tftpboot/centos7
		cp /mnt/images/pxeboot/initrd.img  /var/lib/tftpboot/centos7
		cp -rv /mnt/*  /var/ftp/pub/
		chmod -R 755 /var/ftp/pub
	elif [ $answer == "2" ]
	then
		echo "works 2"
	else
		echo "Buy"
	fi
	functionstart
fi
