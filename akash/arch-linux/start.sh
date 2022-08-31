#!/bin/bash
source $HOME/.bashrc
source $HOME/.bash_profile

# Timezone
timedatectl set-timezone America/Chicago

# Install
pacman --noconfirm -Syyu openssh sudo go git wget curl nginx base-devel inetutils systemd systemd-sysvcompat

# non core installs
pacman --noconfirm -Syyu python-pip zip unzip lsof jq dos2unix btop nano cronie neofetch screen

# File increase limits
echo "65535" > /proc/sys/fs/file-max
echo "fs.file-max = 65535" >> /etc/sysctl.conf
echo "root hard nofile 150000" >> /etc/security/limits.conf
echo "root soft nofile 150000" >> /etc/security/limits.conf
echo "* hard nofile  150000" >> /etc/security/limits.conf
echo "* soft nofile 150000" >> /etc/security/limits.conf

# Change password

if [ -z ${my_root_password+x} ]; then
    echo "my_root_password was not set, so you need to use ssh keys"
else
    echo "my_root_password was set"
    (echo ${my_root_password}; echo ${my_root_password}) | passwd root
fi

# check if the variable my_ssh_pub_key was set
if [ -z ${my_ssh_pub_key+x} ]; then
    echo "my_ssh_pub_key was not set"
else
    echo "my_ssh_pub_key was set, adding key to authorized_keys"
    mkdir -p /root/.ssh
    touch /root/.ssh/authorized_keys
    echo -e "${my_ssh_pub_key}" >> /root/.ssh/authorized_keys
fi

# Gernerate SSH keys & setup sshd
ssh-keygen -A
sudo touch /etc/ssh/sshd_config
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
sed -i -e 's/^UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

# You have to start directly from the files, you cant systemctl / service bc systemd things
/usr/sbin/sshd -p 22 -f /etc/ssh/sshd_config
/usr/bin/nginx -g 'pid /run/nginx.pid; error_log stderr;'
/usr/sbin/crond -i

# makes the directory we put persistant storage on, /root/storage
mkdir -p /root/storage/
echo "BASIC ARCH INSTALL COMPLETE, YOU CAN NOW SSH IN."