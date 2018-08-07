
!/bin/sh
# Enhanced authentication method for Apache Knox and Ranger
#
# Bash tutorial: http://linuxconfig.org/Bash_scripting_Tutorial#8-2-read-file-into-bash-array
# My scripting link: http://www.macs.hw.ac.uk/~hwloidl/docs/index.html#scripting
#
# Usage: 
# -----------------------------------------------------------------------------
echo "Initial Installation"
add-apt-repository ppa:webupd8team/java

# -----------------------------------------------------------------------------
apt-get install oracle-java8-installer
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Configuration of LDAP and PAM (Openldap)
apt install slapd ldap-utils
# -----------------------------------------------------------------------------
# Omit LDAP server configuration: NO
# DNS Domain Name: apache.org or DNS Sub Domain Name :hadoop.apache.org
# Administrative root password : Please provide the root user password
# Database Backend : select HDB
# Do you want the database to be removed when slapd is purged? No.
# Move old database? Yes
# Allow LDAPv2 protocol? No 
# -----------------------------------------------------------------------------
dpkg-reconfigure slapd
# -----------------------------------------------------------------------------

cp ldap.conf  /etc/ldap/ldap.conf

# -----------------------------------------------------------------------------

apt-get install sssd libpam-sss libnss-sss libnss-ldap
apt-get install openssh-server

# -----------------------------------------------------------------------------
cp  sssd.conf  /etc/sssd/sssd.conf

chmod 0600 /etc/sssd/sssd.conf

ldapadd -x -D cn=admin,dc=apache,dc=org -W -f sample.ldif 

ldapadd -x -D cn=admin,dc=apache,dc=org -W -f sampleList.ldif

# -----------------------------------------------------------------------------
cp common-session    /etc/pam.d/common-session

cp common-password   /etc/pam.d/common-password

cp common-auth       /etc/pam.d/common-auth

cp common-session-noninteractive   /etc/pam.d/common-session-noninteractive

# -----------------------------------------------------------------------------

systemctl start sssd.service

systemctl status  sssd.service

# -----------------------------------------------------------------------------
systemctl start sshd.service

systemctl status  sshd.service

