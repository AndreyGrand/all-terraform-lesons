#!/bin/bash
yum -y update
yum -y install httpd
PrivateIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
cat <<EOF > /var/www/html/index.html
<html>
<body bgcolor=black><center><h2><p><font color=red>
Hello 4uvaki from $PrivateIP on  $(date)</p>
<p>Usage external script</p>
</h2></center>
<br>Hello World!!!"
<h2 bgcolor=green>Version 3</h2> 
</body>
</html>
EOF
service httpd start
chkconfig httpd on
echo "UserData executed on $(date)" >> /var/www/html/log.txt
