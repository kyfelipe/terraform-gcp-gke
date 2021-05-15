terraform {
  backend "gcs" {
    bucket  = "conductor-gke-challenge"
    prefix  = "terraform"
  }
}
