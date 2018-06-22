#!/bin/bash

#Prepares a Postgres database to be used as a back-end for a Django server.

if [ -e /var/lib/pgsql/data/pg_hba.conf ]; then exit 0; fi

#Installs python package manager, GNU compiler, and Postgres.
yum install python-pip python-devel gcc postgresql-server postgresql-devel postgresql-contrib -y

postgresql-setup initdb

systemctl start postgresql
systemctl enable postgresql


echo -e "CREATE DATABASE myproject;
\n
CREATE USER myprojectuser WITH PASSWORD 'password';
\n
ALTER ROLE myprojectuser SET client_encoding TO 'utf8';
\n
ALTER ROLE myprojectuser SET default_transaction_isolation TO 'read committed';
\n
ALTER ROLE myprojectuser SET timezone TO 'UTC';
\n
ALTER USER postgres WITH PASSWORD 'P@ssw0rd1';
GRANT ALL PRIVILEGES ON DATABASE myproject TO myprojectuser;" > sqlfile.sql

sudo -i -u postgres psql -U postgres -f /sqlfile.sql

sed -i.bak 's/ident/md5/g' /var/lib/pgsql/data/pg_hba.conf
sed -i 's/local   all             all                                     peer/local   all             all                                     md5/g' /var/lib/pgsql/data/pg_hba.conf
sed -i 's|host    all             all             127.0.0.1/32            md5|host    all             all             all            md5|g' /var/lib/pgsql/data/pg_hba.conf


systemctl start httpd
systemctl enable httpd
systemctl start postgresql
systemctl enable postgresql


yum install phpPgAdmin -y

sed -i 's/$conf\['\''extra_login_security'\''\] = true;/$conf\['\''extra_login_security'\''\] = false;/g' /etc/phpPgAdmin/config.inc.php
#ip/phpPgAdmin Usr: postgres PW: P@ssw0rd1
setenforce 0

sed -i 's/Require local/Require all granted/g' /etc/httpd/conf.d/phpPgAdmin.conf

sed -i 's/Allow from 127.0.0.1/Allow from all/g' /etc/httpd/conf.d/phpPgAdmin.conf

sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /var/lib/pgsql/data/postgresql.conf

sed -i 's/#port/port/g' /var/lib/pgsql/data/postgresql.conf


systemctl restart httpd
systemctl restart postgresql
