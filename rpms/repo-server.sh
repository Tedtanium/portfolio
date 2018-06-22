#!/bin/bash

# This script sets up a repository server on a CentOS box.

if [ -e /repos/centos/7/extras/x86_64/Packages/ ]; then exit 0; fi

setenforce 0

yum -y install createrepo
mkdir -p /repos/centos/7/extras/x86_64/Packages/ 
mv helloworld-0.1-1.el7.centos.x86_64.rpm  /
cp helloworld-0.1-1.el7.centos.x86_64.rpm /repos/centos/7/extras/x86_64/Packages
createrepo --update /repos/centos/7/extras/x86_64/Packages/
yum -y install httpd 
setenforce 0
systemctl enable httpd
systemctl start httpd
ln -s  /repos/centos /var/www/html/centos    
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.bak  
sed -i '144i     Options All' /etc/httpd/conf/httpd.conf       
sed -i '145i    # Disable directory index so that it will index our repos' /etc/httpd/conf/httpd.conf
sed -i '146i     DirectoryIndex disabled' /etc/httpd/conf/httpd.conf
sed -i 's/^/#/' /etc/httpd/conf.d/welcome.conf 
chown -R apache:apache /repos/
systemctl restart httpd

