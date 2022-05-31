#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>Webserver with IP: $myip</h2><br>Build by Terraform!!! version 1.0" > /var/www/html/index.html
sudo service httpd start
chkconfig httpd on
