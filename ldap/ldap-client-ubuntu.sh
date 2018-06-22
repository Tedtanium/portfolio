#!/bin/bash

# This assumes the client is running Ubuntu.

#Aborts the script if ldap.conf is present; this prevents problems from multiple runs of the script.
if [ -e /etc/ldap.conf ]; then exit 0; fi

sudo apt-add-repository universe

apt-get update

declare -a PKG_LIST=(python-google-compute-engine \
python3-google-compute-engine \
google-compute-engine-oslogin \
gce-compute-image-packages)
for pkg in ${PKG_LIST[@]}; do
   sudo apt install -y $pkg || echo "Not available: $pkg"
done

export DEBIAN_FRONTEND=noninteractive
apt-get --yes install libpam-ldap nscd
wget https://raw.githubusercontent.com/Tedtanium/portfolio/master/ldap/ldap_debconf

while read line; do echo "$line" | debconf-set-selections; done < ldap_debconf

apt-get install -y libpam-ldap nscd

sed -i 's/compat/compat ldap/g' /etc/nsswitch.conf

#sed -i 's/PasswordAuthentication no/PasswordAuthentication Yes/g' /etc/ssh/sshd_config

systemctl enable nscd
/etc/init.d/nscd restart

export DEBIAN_FRONTEND=interactive

#The LDAPIP needs to be filled in with the internal IP of the LDAP server, same with ldap_debconf.
sed -i 's,uri ldapi:///,uri ldap://LDAPIP,g' /etc/ldap.conf
sed -i 's/base dc=example,dc=net/base dc=capstone,dc=local/g' /etc/ldap.conf

#Log is found in /var/log/syslog.
