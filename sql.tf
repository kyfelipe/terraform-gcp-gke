resource "google_sql_database" "master" {
  name     = "conductor-master"
  instance = google_sql_database_instance.master_primary.name
}

resource "google_sql_database_instance" "master_primary" {
  name                = "${local.config.sql.name}-${random_id.db_name_suffix.hex}"
  region              = local.config.project.region
  database_version    = local.config.sql.database_version
  root_password       = local.config.sql.root_password
  deletion_protection = local.config.sql.deletion_protection

  settings {
    tier = local.config.sql.instance

    availability_type = local.config.sql.availability_type

    disk_type       = local.config.sql.disk.type
    disk_size       = local.config.sql.disk.size
    disk_autoresize = local.config.sql.disk.autoresize

    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.gke_database.id
    }
  }

  depends_on = [
    google_service_networking_connection.gke_database
  ]
}

resource "google_sql_user" "db_user" {
  name     = local.config.sql.user.name
  password = local.config.sql.user.password
  instance = google_sql_database_instance.master_primary.name
}
