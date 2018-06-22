#!/bin/bash

#Extremely simple code to enable net-snmp on devices. Required for Cacti to monitor system performance. Works for both CentOS and Ubuntu.

yum install -y net-snmp
apt-get install snmp -y

systemctl enable snmpd
systemctl start snmpd
