#!/bin/bash
source $HOME/.bashrc
source $HOME/.bash_profile

# Timezone
timedatectl set-timezone America/Chicago

# Install
pacman --noconfirm -Syyu openssh sudo go git wget curl nginx base-devel

# non core installs
pacman --noconfirm -Syyu python-pip zip unzip lsof jq dos2unix btop nano

# Crontab
# pacman --noconfirm -Syyu cron
# systemctl enable cronie && systemctl start cronie

# Performance Increase
echo "65535" > /proc/sys/fs/file-max
echo "fs.file-max = 65535" >> /etc/sysctl.conf
echo "root hard nofile 150000" >> /etc/security/limits.conf
echo "root soft nofile 150000" >> /etc/security/limits.conf
echo "* hard nofile  150000" >> /etc/security/limits.conf
echo "* soft nofile 150000" >> /etc/security/limits.conf


sudo touch /etc/ssh/sshd_config
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
# fix sshd
sed -i -e 's/^UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config # not tested yet
(echo ${my_root_password}; echo ${my_root_password}) | passwd root
# systemctl restart sshd
# systemctl start nginx
service sshd restart
service nginx start
# runsvdir -P /etc/service &

mkdir -p /root/storage/