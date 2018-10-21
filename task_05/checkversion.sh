#!/usr/bin/env bash
echo '' > ./result.txt
chechHttpRun=$(systemctl status httpd  | grep -o running)
if [[ $chechHttpRun == 'running' ]]; then
  checkhttpExist=$(rpm -q http | grep -o http)
  if [[ $checkhttpExist == 'http' ]]; then
    function checkhttp() {
      name='http'
      httpV=$(rpm -q httpd | cut -c7-14)
      httpP=$(lsof -i -P -n  | grep LISTEN| grep  httpd | head -n1 | awk '{print $9}')
      echo $name $httpV $httpP >> ./result.txt
    }
    checkhttp
  fi
fi

chechTomcatRun=$(systemctl status tomcat  | grep -o running)
if [[ $chechTomcatRun == 'running' ]]; then
  checkTomExist=$(rpm -q tomcat | grep -o tomcat)
  if [ $checkTomExist == 'tomcat' ]; then
    function checktomcat() {
      nameapp='Tomcat'
      tomcatV=$(rpm -q  tomcat | cut -c8-13)
      tomcatP=$(lsof -i -P -n | grep LISTEN | grep tomcat | head -n1| awk '{print $9}')
      echo $nameapp $tomcatV $tomcatP >> ./result.txt
    }
    checktomcat
  fi
fi

chechNginxRun=$(systemctl status nginx  | grep -o running)
if [[ $chechNginxRun == 'running' ]]; then
  checkNginxExist=$(rpm -q nginx| grep -o nginx)
  if [[ $checkNginxExist == 'nginx' ]]; then
    function checknginx() {
      nameapp='Nginx'
      appv=$(rpm -q  nginx | cut -c7-12)
      appP=$(lsof -i -P -n | grep LISTEN | grep nginx | head -n1| awk '{print $9}')
      echo $nameapp $appv $appP >> ./result.txt
    }
    checknginx
  fi
fi

awk 'BEGIN {printf(" %s  %8s  %8s \n", "Apps", "Version", "Port")}
    {printf("%5.7s %9.7s %9.7s\n", $1,  $2, $3)}' result.txt
