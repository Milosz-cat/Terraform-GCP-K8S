resource "google_compute_instance" "k8s_vm" {
  count        = 3
  name         = var.vm_names[count.index]
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20240927"
    }
    disk_encryption_key_raw = var.disk_encryption_key_raw
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnet.name
  }

  metadata = {
    block-project-ssh-keys = true,
    ssh-keys               = "${var.ssh_user}:${tls_private_key.ssh_key.public_key_openssh}",
    startup-script         = replace(
      templatefile("${path.module}/startup-script-master.sh.tpl", {
        ssh_user       = var.ssh_user,
        ssh_public_key = tls_private_key.ssh_key.public_key_openssh
      }),
      "\r\n", "\n"
    )
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  service_account {
    email  = google_service_account.custom_service_account.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

# Creating hosts.ini file from template
resource "local_file" "ansible_inventory" {
  content = templatefile("hosts.ini.tpl", {
    master_ip  = google_compute_instance.k8s_vm[0].network_interface[0].network_ip,
    worker1_ip = google_compute_instance.k8s_vm[1].network_interface[0].network_ip,
    worker2_ip = google_compute_instance.k8s_vm[2].network_interface[0].network_ip,
    ssh_user   = var.ssh_user
  })

  filename = "hosts.ini"
}

resource "google_compute_instance" "ansible_controller" {
  name         = "ansible-controller"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20240927"
    }
    disk_encryption_key_raw = var.disk_encryption_key_raw
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnet.name
  }

  metadata = {
    block-project-ssh-keys = true,
    ssh-keys               = "${var.ssh_user}:${tls_private_key.ssh_key.public_key_openssh}",
    startup-script         = replace(
      templatefile("${path.module}/startup-script-ansible.sh.tpl", {
        ssh_user            = var.ssh_user,
        ssh_private_key     = tls_private_key.ssh_key.private_key_pem,
        hosts_ini_content   = local_file.ansible_inventory.content,
        ansible_cfg_content = replace(file("${path.module}/ansible.cfg"), "\r\n", "\n"),
        playbook_content    = replace(file("${path.module}/playbook.yml"), "\r\n", "\n")
      }),
      "\r\n", "\n"
    )
    startup-script-timeout = "6000"
  }

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  service_account {
    email  = google_service_account.custom_service_account.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  depends_on = [
    local_file.ansible_inventory
  ]  
}
