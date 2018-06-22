#!/bin/bash

#This enables a client to be monitored by Nagios. NAGIOSIP must be replaced with the IP of the Nagios server.

yum install nrpe-selinux -y
yum install nrpe -y
yum install nagios-plugins-all -y
sed -i 's/allowed_hosts=127.0.0.1/allowed_hosts=127.0.0.1, NAGIOSIP/g' /etc/nagios/nrpe.cfg
sed -i "s,command[check_hda1]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/hda1,command[check_disk]=/usr/lib/nagios/plugins/check_disk -w 20% -c 10% -p /dev/sda1,g" /etc/nagios/nrpe.cfg

echo "command[check_mem]=/usr/lib/nagios/plugins/check_mem.sh -w 80 -c 90" >> /etc/nagios/nrpe.cfg

chmod +x check_mem.sh
/etc/init.d/nagios-nrpe-server restart
systemctl restart nagios-nrpe-server
