#!/bin/bash
source $HOME/.bashrc
pacman --noconfirm -Syyu go git wget curl nginx
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
(echo ${my_root_password}; echo ${my_root_password}) | passwd root
systemctl restart sshd
systemctl start nginx
sleep 5
pacman -Su nano
runsvdir -P /etc/service &
source $HOME/.bashrc

