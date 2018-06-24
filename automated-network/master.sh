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
    sed -i "s/REPOIP/$REPOIP/g" /portfolio/nagios/nagios-server.sh
    ################# ^ Needs to go on everything basically. ##################
    
    gcloud compute instances create nagios	--metadata-from-file startup-script=/portfolio/nagios/nagios-server.sh --image centos-7 --tags http-server --zone us-east1-b --machine-type f1-micro 	--scopes cloud-platform 
    sleep 170s
  fi
  
  if [ $NAME = 'ldap' ]; then
    gcloud compute instances create ldap	--metadata-from-file startup-script=/portfolio/ldap/ldap-server.sh --image centos-7 --tags http-server --zone us-east1-b --machine-type f1-micro 	--scopes cloud-platform 
    LDAPIP=$(getent hosts $NAME.c.triple-nectar-194121.internal | awk '{ print $1 }')
    sed -i "s/LDAPIP/$LDAPIP/g" /portfolio/ubuntu-client/client.sh 
  fi
  
  
  if [ $NAME = 'nfs' ]; then
    gcloud compute instances create nfs	--metadata-from-file startup-script=/portfolio/nfs/nfs-server.sh --image centos-7 --zone us-east1-b --machine-type f1-micro 	--scopes cloud-platform 
    NFSIP=$(getent hosts $NAME.c.triple-nectar-194121.internal | awk '{ print $1 }')
    sed -i "s/NFSIP/$NFSIP/g" /portfolio/ubuntu-client/client.sh  
  fi
  
  
  if [ $NAME = 'postgres' ]; then
    gcloud compute instances create postgres	--metadata-from-file startup-script=/portfolio/django-on-postgres/postgres.sh --image centos-7 --tags http-server --zone us-east1-b --machine-type f1-micro 	--scopes cloud-platform 
    POSTGRESIP=$(getent hosts $NAME.c.triple-nectar-194121.internal | awk '{ print $1 }')
    sed -i "s/POSTGRESIP/$POSTGRESIP/g" /portfolio/django-on-postgres/django.sh 
  fi
  
  if [ $NAME = 'repo-server' ]; then
    gcloud compute instances create repo-server --metadata-from-file startup-script=/portfolio/rpms/repo-server.sh --image centos-7 --tags "http-server","djangoisonfiresomebodycall911" --zone us-east1-b --machine-type f1-micro --scopes cloud-platform 
    REPOIP=$(getent hosts $NAME.c.triple-nectar-194121 | awk '{ print $1 }')
  fi
  
  if [ $NAME = 'django' ]; then
    gcloud compute instances create django --metadata-from-file startup-script=nti-320-linux-monitoring/automated-network/django.sh --image centos-7 --tags "http-server","djangoisonfiresomebodycall911" --zone us-east1-b --machine-type f1-micro --scopes cloud-platform 
  fi
  
  
  if [ $NAME = 'load-balancer' ]; then 
    gcloud compute instances create load-balancer	--metadata-from-file startup-script=/portfolio/load-balancer/load-balancer.sh --image centos-7 --tags http-server --zone us-east1-b --machine-type f1-micro 	--scopes cloud-platform 
  fi
  
  if [ $NAME = 'cacti' ]; then
    gcloud compute instances create cacti	--metadata-from-file startup-script=/portfolio/cacti/cacti-server.sh --image centos-7 --tags http-server --zone us-east1-b --machine-type f1-micro 	--scopes cloud-platform 
  fi
  
  if [ $NAME = 'client' ]; then
    gcloud compute instances create client-a	--metadata-from-file startup-script=/portfolio/automated-network/client.sh --image-family ubuntu-1604-lts --image-project ubuntu-os-cloud --zone us-east1-b --machine-type f1-micro 	--scopes cloud-platform 
    # ^ This line can be run multiple times for more clients, so long as the "-a" is changed.
  fi
  
  if [ $NAME = 'build-server' ]; then
    gcloud compute instances create build-server	--metadata-from-file startup-script=/portfolio/rpms/build-server.sh --image centos-7 --zone us-east1-b --machine-type f1-micro 	--scopes cloud-platform    
  fi
  
  if [ $NAME = 'rsyslog' ]; then
    gcloud compute instances create rsyslog	--metadata-from-file startup-script=/portfolio/rsyslog/rsyslog-server.sh --image centos-7 --zone us-east1-b --machine-type f1-micro 	--scopes cloud-platform    
  fi
  
  if [ $NAME != 'nagios' ]; then
    IP=$(getent hosts $NAME.c.triple-nectar-194121.internal | awk '{ print $1 }')
    #Runs the Nagios client creation script on the Nagios server, passing hostname and IP variables as arguments.
    su - tjense04 -c "gcloud compute ssh --zone us-east1-b nagios --quiet --command "\""sudo bash /generate-nagios-client.sh $NAME $IP"\"""
    fi
  
done
