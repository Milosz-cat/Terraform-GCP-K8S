[masters]
test-master ansible_host=${master_ip} ansible_user=miloszbochenek13 ansible_ssh_private_key_file=/home/${ssh_user}/.ssh/id_rsa

[workers]
test-worker-1 ansible_host=${worker1_ip} ansible_user=miloszbochenek13 ansible_ssh_private_key_file=/home/${ssh_user}/.ssh/id_rsa
test-worker-2 ansible_host=${worker2_ip} ansible_user=miloszbochenek13 ansible_ssh_private_key_file=/home/${ssh_user}/.ssh/id_rsa

[all:vars]
ansible_python_interpreter=/usr/bin/python3