#!/bin/bash

# This will spin up an LDAP server automatically on GCP, assuming the OS is CentOS 7 or Redhat.

yum install openldap-servers -y
yum install openldap-clients -y
yum install wget -y

cp /usr/share/openldap-servers/DB_CONFIG.example /var/lib/ldap/DB_CONFIG
chown ldap. /var/lib/ldap/DB_CONFIG

systemctl enable slapd
systemctl start slapd

yum install httpd -y
yum install epel-release -y
yum install phpldapadmin -y

setsebool -P httpd_can_connect_ldap on

systemctl start httpd
systemctl enable httpd

sed -i 's,Require local,#Require local\n   Require all granted,g' /etc/httpd/conf.d/phpldapadmin.conf

unalias cp

wget https://raw.githubusercontent.com/Tedtanium/NTI-470-Capstone-Project/master/machine-scripts/configs/ldap/config.php
cp /config.php /etc/phpldapadmin/config.php
chown ldap:apache /etc/phpldapadmin/config.php

systemctl restart httpd.service

newsecret=$(slappasswd -g)
newhash=$(slappasswd -s "$newsecret")
echo -n "$newsecret" > /root/ldap_admin_pass
chmod 0600 /root/ldap_admin_pass

echo -e "dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: dc=capstone,dc=local
\n
dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: cn=ldapadm,dc=capstone,dc=local
\n
dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: $newhash" > /db.ldif

ldapmodify -Y EXTERNAL  -H ldapi:/// -f db.ldif

echo 'dn: olcDatabase={1}monitor,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external, cn=auth" read by dn.base="cn=ldapadm,dc=capstone,dc=local" read by * none' > /monitor.ldif

ldapmodify -Y EXTERNAL  -H ldapi:/// -f /monitor.ldif

#Certgen.

openssl req -new -x509 -nodes -out /etc/openldap/certs/capstoneldapcert.pem -keyout /etc/openldap/certs/capstoneldapkey.pem -days 365 -subj "/C=US/ST=WA/L=Seattle/O=SCC/OU=IT/CN=capstone.local"

chown -R ldap. /etc/openldap/certs/capstone*.pem

echo -e "dn: cn=config
changetype: modify
replace: olcTLSCertificateFile
olcTLSCertificateFile: /etc/openldap/certs/capstoneldapcert.pem
\n
dn: cn=config
changetype: modify
replace: olcTLSCertificateKeyFile
olcTLSCertificateKeyFile: /etc/openldap/certs/capstoneldapkey.pem" > /certs.ldif


ldapmodify -Y EXTERNAL  -H ldapi:/// -f /certs.ldif



ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/cosine.ldif
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/nis.ldif 
ldapadd -Y EXTERNAL -H ldapi:/// -f /etc/openldap/schema/inetorgperson.ldif

echo -e "dn: dc=capstone,dc=local
dc: capstone
objectClass: top
objectClass: domain
\n
dn: cn=ldapadm ,dc=capstone,dc=local
objectClass: organizationalRole
cn: ldapadm
description: LDAP Manager
\n
dn: ou=People,dc=capstone,dc=local
objectClass: organizationalUnit
ou: People
\n
dn: ou=Group,dc=capstone,dc=local
objectClass: organizationalUnit
ou: Group" > /base.ldif

setenforce 0

ldapadd -x -W -D "cn=ldapadm,dc=capstone,dc=local" -f /base.ldif -y /root/ldap_admin_pass

#Use [cat /root/ldap_admin_pass] to retrieve the password for use in the web interface.
#Further troubleshooting: Run the last line to test, otherwise use [grep startup-script /var/log/messsages].
