# variable "gke_username" {
#   default     = "admin"
#   description = "gke username"
# }

# variable "gke_password" {
#   default     = "123456"
#   description = "gke password"
# }

# GKE cluster
resource "google_container_cluster" "primary" {
  name     = local.config.project.name
  location = local.config.project.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  # master_auth {
  #   username = var.gke_username
  #   password = var.gke_password

  #   client_certificate_config {
  #     issue_client_certificate = false
  #   }
  # }

  release_channel {
    channel = "REGULAR"
  }
}

# Data GKE versions
data "google_container_engine_versions" "gke" {
  location       = local.config.project.region
  version_prefix = local.config.gke.version_prefix
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  location   = local.config.project.region
  cluster    = google_container_cluster.primary.name
  node_count = local.config.gke.nodes.primary.count
  version    = data.google_container_engine_versions.gke.latest_node_version

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      cluster_name = google_container_cluster.primary.name
    }

    machine_type = local.config.gke.nodes.primary.machine_type
    tags         = ["gke-node", "${local.config.project.id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

# provider "kubernetes" {
#   load_config_file = "false"

#   host     = google_container_cluster.primary.endpoint
#   username = var.gke_username
#   password = var.gke_password

#   client_certificate     = google_container_cluster.primary.master_auth.0.client_certificate
#   client_key             = google_container_cluster.primary.master_auth.0.client_key
#   cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
# }
