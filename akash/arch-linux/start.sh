#!/bin/bash
source $HOME/.bashrc
pacman --noconfirm -Syyu go git wget curl nginx
sudo touch /etc/ssh/sshd_config
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
(echo ${my_root_password}; echo ${my_root_password}) | passwd root
systemctl restart sshd
systemctl start nginx
sleep 5
pacman -Su nano --noconfirm
runsvdir -P /etc/service &
source $HOME/.bashrc

