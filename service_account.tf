resource "google_service_account" "account" {
  account_id  = "cloud-sql-proxy"
  description = "The service account used by Cloud SQL Proxy to connect to the db"
}

resource "google_project_iam_member" "role" {
  role   = "roles/cloudsql.editor"
  member = "serviceAccount:${google_service_account.account.email}"
}

# resource "google_project_iam_binding" "workload_identity_user" {
#   role    = "roles/iam.workloadIdentityUser"

#   members = [
#     "serviceAccount:${local.config.project.id}.svc.id.goog[default/gcloud-psql]",
#   ]
# }

resource "google_service_account_key" "key" {
  service_account_id = google_service_account.account.name
}
