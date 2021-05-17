output "region" {
  value       = local.config.project.region
  description = "GCloud Region"
}

# output "project_id" {
#   value       = var.project_id
#   description = "GCloud Project ID"
# }

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

# output "kubernetes_cluster_host" {
#   value       = google_container_cluster.primary.endpoint
#   description = "GKE Cluster Host"
# }

output "database_connection_name" {
  value       = google_sql_database_instance.master_primary.connection_name
  description = "Cloud SQL connection name"
}

output "database_ip" {
  value       = google_sql_database_instance.master_primary.ip_address.0.ip_address
  description = "Cloud SQL Database IP"
}

output "database_private_ip" {
  value       = google_sql_database_instance.master_primary.private_ip_address
  description = "Cloud SQL Database private IP"
}
