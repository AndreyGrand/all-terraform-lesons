#!/bin/bash
yum -y update
yum -y install httpd
PrivateIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<html><body bgcolor=black><center><h2><p><font color=red>Hello 4uvaki from $PrivateIP on  $(date)</p><p>Usage external script</p></h2></center></body></html>" > /var/www/html/index.html
echo "<br>Hello World!!!" >> /var/www/html/index.html
service httpd start
chkconfig httpd on
echo "UserData executed on $(date)" >> /var/www/html/log.txt
