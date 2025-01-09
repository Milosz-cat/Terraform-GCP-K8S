output "master_ip" {
  value = google_compute_instance.k8s_vm[0].network_interface[0].network_ip
  description = "Adres IP instancji master"
}

output "worker1_ip" {
  value = google_compute_instance.k8s_vm[1].network_interface[0].network_ip
  description = "Adres IP instancji worker-1"
}

output "worker2_ip" {
  value = google_compute_instance.k8s_vm[2].network_interface[0].network_ip
  description = "Adres IP instancji worker-2"
}

output "ansible_controller_ip" {
  value = google_compute_instance.ansible_controller.network_interface[0].network_ip
  description = "Adres IP instancji ansible-controller"
}