#!/bin/bash

#This scriptlet makes any given client (CentOS only) point to a given repository server as a source to get RPMs from.
#REPOIP must be replaced with the internal IP of the repository server.

echo "[example-repository]
name=Extra Packages for Centos from example-repository 7 - $basearch
#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch <- example epel repo
# Note, this is putting repodata at packages instead of 7 and our path is a hack around that.
baseurl=http://REPOIP/centos/7/extras/x86_64/Packages/
enabled=1
gpgcheck=0
" >> /etc/yum.repos.d/example-repository.repo  
