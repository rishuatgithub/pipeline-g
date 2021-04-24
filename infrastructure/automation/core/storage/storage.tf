variable "bucket_name" {} 
variable "bucket_region" {}
variable "bucket_force_destroy" {
  default = true
}

resource "google_storage_bucket" "storage" {
  name = var.bucket_name
  location = var.bucket_region
  force_destroy = var.bucket_force_destroy
}

output "bucket_name" {
  description = "cloud storage bucket name"
  value = google_storage_bucket.storage.name
}