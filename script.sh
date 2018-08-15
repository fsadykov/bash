#!/bin/bash
HOST='10.0.100.104'
USER='admin'
PASSWD='redhat'
sftp -P 22 $USER@$HOST
lcd /SFTP/files/
put /My_scripts/ftp/file.txt 
