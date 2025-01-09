resource "google_compute_firewall" "allow_kubernetes_cluster" {
  name    = "allow-kubernetes-cluster"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["8472"] # VXLAN for Flannel
  }
  
  allow {
    protocol = "icmp"
  }

  source_ranges = ["192.168.0.0/16", "35.235.240.0/20", "10.200.0.0/20"]
}
