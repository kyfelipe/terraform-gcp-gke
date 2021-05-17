# GKE cluster
resource "google_container_cluster" "primary" {
  name     = local.config.project.name
  location = local.config.project.region

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.gke_database.name
  subnetwork = google_compute_subnetwork.gke_database.name

  node_config {
    service_account = google_service_account.account.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  workload_identity_config {
    identity_namespace = "${local.config.project.id}.svc.id.goog"
  }

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
