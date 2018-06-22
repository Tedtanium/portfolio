#!/bin/bash

#This creates a Nagios server, which is used for more real-time system monitoring. Can be configured to alert the user via email or text if something goes down. 

if [ -e /etc/nagios/objects/commands.cfg ]; then exit 0; fi

yum install nagios nrpe nagios-plugins-all nagios-plugins-nrpe nagios-selinux httpd wget -y

wget https://raw.githubusercontent.com/Tedtanium/nti-320-linux-monitoring/master/automated-network/configs/generate-nagios-client.sh

systemctl enable nagios
systemctl start nagios
systemctl enable nrpe
systemctl start nrpe
systemctl enable httpd
systemctl start httpd



echo '########### NRPE CONFIG LINE #######################
define command{
command_name check_nrpe
command_line $USER1$/check_nrpe -H $HOSTADDRESS$ -c $ARG1$
}' >> /etc/nagios/objects/commands.cfg


#Disables authentication.
sed -i 's/use_authentication=1/use_authentication=0/g' /etc/nagios/cgi.cfg
sed -i 's/#default_user_name=guest/default_user_name=guest/g' /etc/nagios/cgi.cfg
sed -i 's/AuthName/#Authname/g' /etc/httpd/conf.d/nagios.conf
sed -i 's/AuthType/#AuthType/g' /etc/httpd/conf.d/nagios.conf
sed -i 's/AuthUserFile/#AuthUserFile/g' /etc/httpd/conf.d/nagios.conf
sed -i 's/Require valid/#Require valid/g' /etc/httpd/conf.d/nagios.conf

systemctl restart nagios
systemctl restart httpd

#To validate configs: Run /usr/sbin/nagios -v /etc/nagios/nagios.cfg.


# Sleeps for a bit for the rest of the network to finish spinning up (and for clients to propogate). Uncomment the sleep command if running from the master.sh script.
# sleep 3m

systemctl restart nagios
systemctl restart httpd
