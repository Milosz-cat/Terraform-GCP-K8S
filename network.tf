resource "google_compute_network" "vpc_network" {
  name                    = "k8s-terraform-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name                    = "k8s-subnet"
  ip_cidr_range           = "10.200.0.0/20"
  network                 = google_compute_network.vpc_network.self_link
  region                  = var.region
  private_ip_google_access = true
  
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

resource "google_compute_router" "nat_router" {
  name    = "nat-router"
  network = google_compute_network.vpc_network.name
  region  = var.region
}

resource "google_compute_router_nat" "cloud_nat" {
  name                               = "cloud-nat"
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY" # Automatic IP address assignment for Cloud NAT
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES" # NAT for all subnetworks and IP ranges

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
