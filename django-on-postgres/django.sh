#!/bin/bash

#Prepares a Django server to be run using Postgres as its database backend. POSTGRESIP must be replaced with the Postgres server's internal IP address.

if [ -e opt/myproject/myproject/settings.py ]; then exit 0; fi

yum install python-pip wget telnet -y
pip install virtualenv
pip install --upgrade pip
pip install django psycopg2


mkdir /opt/myproject
virtualenv /opt/myproject/myprojectenv
source /opt/myproject/myprojectenv/bin/activate
django-admin.py startproject myproject /opt/myproject

mv /opt/myproject/myproject/settings.py /opt/myproject/myproject/settings.py.bak


source /opt/myproject/myprojectenv/bin/activate && pip install django psycopg2 && django-admin.py startproject myproject /opt/myproject/
mv /opt/myproject/myproject/settings.py /settings.py.bak

wget https://raw.githubusercontent.com/Tedtanium/nti-310-linux-enterprise-applications/master/django-thing/settings.py --directory-prefix=/opt/myproject/myproject/

postgresip=$(getent hosts postgres.c.nti-310-200201.internal | awk '{ print $1 }')

sed -i "s|'HOST': '1.2.3.4'|'HOST': 'POSTGRESIP'|g" /opt/myproject/myproject/settings.py

#Enables anyone to connect to the web front-end.
sed -i "s/ALLOWED_HOSTS = \[\]/ALLOWED_HOSTS =  \[\'"*"\'\]/g" /opt/myproject/myproject/settings.py


echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', 'pass')" | /opt/myproject/manage.py shell

#Runs the thing. 
source /opt/myproject/myprojectenv/bin/activate && python /opt/myproject/manage.py makemigrations && python /opt/myproject/manage.py migrate && python /opt/myproject/manage.py runserver 0.0.0.0:8000
