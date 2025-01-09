#!/bin/bash

mkdir -p /home/${ssh_user}/.ssh
echo "${ssh_public_key}" > /home/${ssh_user}/.ssh/id_rsa.pub
chmod 700 /home/${ssh_user}/.ssh
chmod 600 /home/${ssh_user}/.ssh/id_rsa.pub
chown -R ${ssh_user}:${ssh_user} /home/${ssh_user}


apt update -y
apt install -y iptables nftables