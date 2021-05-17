# GKE
# resource "google_compute_network" "gke" {
#   name                    = "gke-${local.config.project.name}-vpc"
#   description             = "VPC used by the GKE"
#   auto_create_subnetworks = "false"
# }

# resource "google_compute_subnetwork" "gke" {
#   name          = "${local.config.project.name}-subnet"
#   region        = local.config.project.region
#   network       = google_compute_network.gke.name
#   ip_cidr_range = local.config.network.ip_cidr_range
# }

# # SQL Database
# resource "google_compute_network" "database" {
#   name        = "database-${local.config.project.name}-vpc"
#   description = "VPC used by the SQL Database"
# }

# resource "google_compute_global_address" "database" {
#   name          = "database-${local.config.project.name}-private-ip"
#   purpose       = "VPC_PEERING"
#   address_type  = "INTERNAL"
#   ip_version    = "IPV4"
#   prefix_length = 20
#   network       = google_compute_network.database.id
# }

# resource "google_service_networking_connection" "database" {
#   network                 = google_compute_network.database.id
#   service                 = "servicenetworking.googleapis.com"
#   reserved_peering_ranges = [google_compute_global_address.database.name]
# }

resource "google_compute_network" "gke_database" {
  name                    = "database-${local.config.project.name}-vpc"
  description             = "VPC used by the SQL Database"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "gke_database" {
  name          = "${local.config.project.name}-subnet"
  region        = local.config.project.region
  network       = google_compute_network.gke_database.name
  ip_cidr_range = local.config.network.ip_cidr_range
}

resource "google_compute_global_address" "gke_database" {
  name          = "database-${local.config.project.name}-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  ip_version    = "IPV4"
  prefix_length = 20
  network       = google_compute_network.gke_database.id
}

resource "google_service_networking_connection" "gke_database" {
  network                 = google_compute_network.gke_database.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.gke_database.name]
}

resource "google_compute_firewall" "allow_http" {
  name        = "allow-http"
  description = "Allow SSH traffic to any instance tagged with 'ssh-enabled'"
  network     = google_compute_network.gke_database.name
  direction   = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80","443"]
  }

  target_tags = ["http-enabled"]
}

# VPC Peering
# resource "google_compute_network_peering" "peering1" {
#   name         = "gke-to-database"
#   network      = google_compute_network.gke.id
#   peer_network = google_compute_network.database.id
# }

# resource "google_compute_network_peering" "peering2" {
#   name         = "gke-to-database"
#   network      = google_compute_network.database.id
#   peer_network = google_compute_network.gke.id
# }
