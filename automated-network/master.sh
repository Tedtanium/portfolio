#!/bin/bash

if [ -e /portfolio ]; then exit 0; fi


############# GCLOUDAPI ###################
#Gets GCloud ready to go.
gcloud init
1
triple-nectar-194121
# ^ GCloud project ID goes there.

################# GIT ####################
#Pulls down repository.
yum install git -y
git clone https://github.com/Tedtanium/portfolio.git

####### FIREWALL RULE CREATION #######
gcloud compute firewall-rules create djangoisonfiresomebodycall911 --allow tcp:8000
# ^ Needs to be run once, will error and abort script if it already exists.


########## For loop. #########################
#Runs a whole ton of instances with conditions.
for line in $(cat /portfolio/automated-network/instances-list); do
  NAME=$line

########## IF STATEMENTS ######################
#These check to see if $NAME matches the case. If so, it launches the instance with required conditions.
## Can be condensed greatly, since most of the conditions are more or less the same.
  
  if [ $NAME = 'nagios' ]; then
    gcloud compute instances create nagios	--metadata-from-file startup-script=portfolio/nagios/nagios-server.sh --image centos-7 --tags http-server --zone us-east1-b --machine-type f1-micro 	--scopes cloud-platform 
    sleep 170s
  fi
  
  if [ $NAME = 'ldap' ]; then
    gcloud compute instances create ldap	--metadata-from-file startup-script=portfolio/ldap/ldap-server.sh --image centos-7 --tags http-server --zone us-east1-b --machine-type f1-micro 	--scopes cloud-platform 
    LDAPIP=$(getent hosts $NAME.c.nti-320-200300.internal | awk '{ print $1 }')
    sed -i "s/LDAPIP/$LDAPIP/g" /portfolio/ldap/ldap-client.sh 
  fi
  
  ######## Ended here. #########
  
  if [ $NAME = 'nfs' ]; then
    gcloud compute instances create nfs	--metadata-from-file startup-script=nti-320-linux-monitoring/automated-network/nfs.sh --image centos-7 --zone us-east1-b --machine-type f1-micro 	--scopes cloud-platform 
    NFSIP=$(getent hosts $NAME.c.nti-320-200300.internal | awk '{ print $1 }')
    sed -i "s/NFSIP/$NFSIP/g" /nti-320-linux-monitoring/automated-network/client.sh 
  fi
  
  
  if [ $NAME = 'postgres' ]; then
    gcloud compute instances create postgres	--metadata-from-file startup-script=nti-320-linux-monitoring/automated-network/postgres.sh --image centos-7 --tags http-server --zone us-east1-b --machine-type f1-micro 	--scopes cloud-platform 
    POSTGRESIP=$(getent hosts $NAME.c.nti-320-200300.internal | awk '{ print $1 }')
    sed -i "s/POSTGRESIP/$POSTGRESIP/g" /nti-320-linux-monitoring/automated-network/django.sh 
  fi
  
  
  if [ $NAME = 'django' ]; then
    gcloud compute instances create django --metadata-from-file startup-script=nti-320-linux-monitoring/automated-network/django.sh --image centos-7 --tags "http-server","djangoisonfiresomebodycall911" --zone us-east1-b --machine-type f1-micro --scopes cloud-platform 
  fi
  
  
  if [ $NAME = 'load-balancer' ]; then 
    gcloud compute instances create load-balancer	--metadata-from-file startup-script=nti-320-linux-monitoring/automated-network/load-balancer.sh --image centos-7 --tags http-server --zone us-east1-b --machine-type f1-micro 	--scopes cloud-platform 
  fi
  
  if [ $NAME = 'cacti' ]; then
    gcloud compute instances create cacti	--metadata-from-file startup-script=nti-320-linux-monitoring/automated-network/cacti.sh --image centos-7 --tags http-server --zone us-east1-b --machine-type f1-micro 	--scopes cloud-platform 
  fi
  
  if [ $NAME = 'client' ]; then
    gcloud compute instances create client-a	--metadata-from-file startup-script=nti-320-linux-monitoring/automated-network/client.sh --image-family ubuntu-1604-lts --image-project ubuntu-os-cloud --zone us-east1-b --machine-type f1-micro 	--scopes cloud-platform 
    gcloud compute instances create client-b	--metadata-from-file startup-script=nti-320-linux-monitoring/automated-network/client.sh --image-family ubuntu-1604-lts --image-project ubuntu-os-cloud --zone us-east1-b --machine-type f1-micro 	--scopes cloud-platform
  fi
  
  if [ $NAME != 'ldap' ] && [ $NAME != 'nfs' ] && [ $NAME != 'postgres' ] && [ $NAME != 'django' ] && [ $NAME != 'load-balancer' ] && [ $NAME != 'client' ] && [ $NAME != 'nagios' ] && [ $NAME != 'cacti' ]; then
    gcloud compute instances create $NAME	--metadata-from-file startup-script=nti-320-linux-monitoring/automated-network/$NAME.sh --image centos-7 --zone us-east1-b --machine-type f1-micro 	--scopes cloud-platform    
  fi
  
  if [ $NAME != 'nagios' ]; then
    IP=$(getent hosts $NAME.c.nti-320-200300.internal | awk '{ print $1 }')
    #Runs the Nagios client creation script on the Nagios server, passing hostname and IP variables as arguments.
    su - tjense04 -c "gcloud compute ssh --zone us-east1-b nagios --quiet --command "\""sudo bash /generate-nagios-client.sh $NAME $IP"\"""
    fi
  
done
