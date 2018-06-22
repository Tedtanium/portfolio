#!/bin/bash

#This should be run every minute as a cron job.

#Greps for LDAP users, and stores their usernames in a file. 
#This one overwrites the old ones, as otherwise the function would get drastically longer with each and every run of it.
getent passwd | grep 500 | awk -F ":" '{print $1}' > ldap-users

#Starts for loop.
for line in $(cat ldap-users);

do
#Stores username as $uservariable.
  uservariable=$line

#Check to see if /home/$uservariable exists; if not then move onto the next section of the for loop (How do?)
  if [ ! -e /home/$uservariable ]
  then
#Creates user directory in /home/$uservariable
    mkdir /home/$uservariable

#Echoes user directory into the /etc/exports file, where it will be shared via NFS. (UNFINISHED)
    echo "/home/$uservariable   *(rw,sync)" >> /etc/exports

#Changes permissions of /home/$uservariable share.
    chmod 0700 /home/$uservariable

#Changes ownership of /home/$uservariable to the user.
    chown  $uservariable /home/$uservariable
#End of the if check.
  fi
#End of for loop.
done
