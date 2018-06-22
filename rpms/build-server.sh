#This script creates a build server on which RPMs can be built on.

yum install rpm-build make gcc git wget -y

#Creates directory for RPM.

mkdir -p /root/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

#To use: First create a tarball from a given installation script (or set of scripts) and place it in /root/rpmbuild/SOURCES. The wget -P command can be useful here.
wget https://github.com/nic-instruction/NTI-320/blob/master/rpm-info/hello_world_from_source/helloworld-0.1.tar.gz?raw=true -P /root/rpmbuild/SOURCES

#Pull down a .spec file and put it in /root/rpmbuild/SPECS. A sample SPEC file is wgetted below.

wget https://raw.githubusercontent.com/nic-instruction/NTI-320/master/rpm-info/hello_world_from_source/hello.spec -P /root/rpmbuild/SPECS

#Builds an RPM file out of the specs file. This ends up being put in the RPMS directory.

rpmbuild -v -bb --clean /root/rpmbuild/SPECS/hello.spec

#From here, the RPM can be moved to a repository server for distribution.
