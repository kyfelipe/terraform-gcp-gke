terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.67.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
  }

  required_version = "~> 0.14"
}
