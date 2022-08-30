#!/bin/bash
source $HOME/.bashrc
# Timezone
timedatectl set-timezone America/Chicago
# Init Install & Upgrade
apt-get update
apt-get upgrade -y
apt-get install -y sudo nano wget tar zip unzip jq goxkcdpwgen ssh nginx build-essential git make gcc nvme-cli pkg-config libssl-dev libleveldb-dev clang bsdmainutils ncdu libleveldb-dev apt-transport-https gnupg2 cron htop
sudo apt-get install -y nano runit

# Allow the root user to SSH in & change password to what we want from the config
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
(echo ${my_root_password}; echo ${my_root_password}) | passwd root

# restart the service for ssh & nginx
service ssh restart
service nginx start
service cron start

# make our persistant storage folder.
mkdir -p /root/storage/



# Performance Increase
echo "65535" > /proc/sys/fs/file-max
echo "fs.file-max = 65535" >> /etc/sysctl.conf
echo "root hard nofile 150000" >> /etc/security/limits.conf
echo "root soft nofile 150000" >> /etc/security/limits.conf
echo "* hard nofile  150000" >> /etc/security/limits.conf
echo "* soft nofile 150000" >> /etc/security/limits.conf