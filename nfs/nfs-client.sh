#!/bin/bash

# Made to work with both Ubuntu and CentOS (yum and apt).
apt-get install nfs-client -y
yum install nfs-client -y

mkdir /ldap/

#Points the NFS client towards the server, then specifies the directory to be mounted. 
#Then specifies how it'll show as a local directory, then specifies NFS usage.
#NFSIP must be replaced with the NFS server's IP address.

echo "NFSIP:/home/ /ldap/ nfs" >> /etc/fstab

mount -a
