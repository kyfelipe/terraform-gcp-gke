# VPC
resource "google_compute_network" "vpc" {
  name                    = "${local.config.project.name}-vpc"
  description             = "VPC used by the Kubernetes cluster"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${local.config.project.name}-subnet"
  region        = local.config.project.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = local.config.network.ip_cidr_range
}
