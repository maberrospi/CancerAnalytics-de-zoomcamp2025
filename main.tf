terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.19.0"
    }
  }
}

provider "google" {
  project     = var.project_id        # Use the project ID from variables.tf
  region      = var.region             # Use the region from variables.tf
  credentials = file(var.credentials) # Use the credentials from variables.tf
}

# GCS Bucket for Data Lake
resource "google_storage_bucket" "cancer-bucket" {
  name          = "${var.project_id}-data-lake"  # Bucket name derived from project_id
  location      = var.location                      # Use the location from variables.tf
  storage_class = var.gcs_storage_class             # Use the storage class from variables.tf
  force_destroy = true

  lifecycle_rule {
    condition {
      age=1 
    }
    action {
      type = "AbortIncompleteMultipartUpload" # Automatically splits data into chunks during upload
    }
  }
}

# BigQuery Dataset for Data Warehouse
resource "google_bigquery_dataset" "cancer_dataset" {
  dataset_id = var.bq_dataset_name # Use the dataset name from variables.tf
  project    = var.project_id     # Use the project ID from variables.tf
  location   = var.location       # Use the location from variables.tf
}