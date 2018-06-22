#!/bin/bash
#This enables any CentOS machine to authenticate as an LDAP client. "LDAPIP" needs to be replaced with the internal IP address of the LDAP server.

yum install -y nss-pam-ldapd nscd

authconfig --enableldap --enableldapauth --ldapserver=ldap://LDAPIP/ --ldapbasedn="dc=capstone,dc=local" --updateall 
