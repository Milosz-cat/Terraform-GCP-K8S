#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

echo "${ssh_private_key}" > /home/${ssh_user}/.ssh/id_rsa
chmod 700 /home/${ssh_user}/.ssh
chmod 600 /home/${ssh_user}/.ssh/id_rsa

# Ansible installation
apt update -y
apt install -y software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt update -y
apt install -y ansible

# Creating hosts.ini file
cat <<'EOF' > /home/${ssh_user}/hosts.ini
${hosts_ini_content}
EOF

# Creating ansible.cfg file
cat <<'EOF' > /etc/ansible/ansible.cfg
${ansible_cfg_content}
EOF

# Creating playbook.yml file
cat <<'EOF' > /home/${ssh_user}/playbook.yml
${playbook_content}
EOF

chown -R ${ssh_user}:${ssh_user} /home/${ssh_user}

# Starting the playbook
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i /home/${ssh_user}/hosts.ini /home/${ssh_user}/playbook.yml -vv
