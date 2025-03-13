variable "credentials" {
  description = "My Credentials"
  default     = "/mnt/c/Users/mab03/Desktop/DataEngineeringZoomcamp_FinalProject/GoogleKeys/zoomcamp-project-cancer-126221568bec.json"
}


variable "project_id" {
  description = "Project"
  default     = "zoomcamp-project-cancer"
}

variable "region" {
  description = "Region"
  default     = "europe-west1"
}

variable "location" {
  description = "Project Location"
  default     = "EU"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "GBD_2021_cancer"
}

# variable "gcs_bucket_name" {
#   description = "My Storage Bucket Name"
#   #Update the below to a unique bucket name
#   default     = "data-lake"
# }

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}