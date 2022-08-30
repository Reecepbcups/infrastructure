#!/bin/bash
source $HOME/.bashrc
source $HOME/.bash_profile

# Timezone
timedatectl set-timezone America/Chicago

# Install
pacman --noconfirm -Syyu openssh sudo go git wget curl nginx base-devel

# non core installs
pacman --noconfirm -Syyu python-pip zip unzip lsof jq dos2unix btop nano cron cronie

# Performance Increase
echo "65535" > /proc/sys/fs/file-max
echo "fs.file-max = 65535" >> /etc/sysctl.conf
echo "root hard nofile 150000" >> /etc/security/limits.conf
echo "root soft nofile 150000" >> /etc/security/limits.conf
echo "* hard nofile  150000" >> /etc/security/limits.conf
echo "* soft nofile 150000" >> /etc/security/limits.conf

(echo ${my_root_password}; echo ${my_root_password}) | passwd root

ssh-keygen -A
sudo touch /etc/ssh/sshd_config
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
sed -i -e 's/^UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config # not tested yet

# you have to start directly from the files, you cant systemctl / service
# start ssh in the background on port 22
/usr/sbin/sshd -p 22 -f /etc/ssh/sshd_config
/usr/bin/nginx -g 'pid /run/nginx.pid; error_log stderr;'
/usr/sbin/crond -i

mkdir -p /root/storage/