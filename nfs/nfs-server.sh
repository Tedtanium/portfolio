#!/bin/bash

#This spins up an NFS server that will automatically authenticate with the LDAP server and automatically supply shares to every user.

#This is already set up to become an LDAP client.

yum install -y nss-pam-ldapd nscd wget nfs-utils

#LDAP config stuff.


#LDAPIP needs to be replaced with the LDAP server's internal IP address.
authconfig --enableldap --enableldapauth --ldapserver=ldap://LDAPIP/ --ldapbasedn="dc=capstone,dc=local" --updateall 



systemctl restart nscd

#NFS stuff starts here.

systemctl enable rpcbind
systemctl enable nfs-server
systemctl enable nfs-lock
systemctl enable nfs-idmap
systemctl start rpcbind
systemctl start nfs-server
systemctl start nfs-lock
systemctl start nfs-idmap

#NFS LDAP integration begins here.
wget https://raw.githubusercontent.com/Tedtanium/portfolio/master/nfs/nfs-auto-update.sh

crontab -l 2>/dev/null; echo "* * * * * /bin/sh /nfsautoupdate.sh" | crontab -

exportfs -a

systemctl restart nfs-server
