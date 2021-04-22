variable "function_name" {}
variable "function_description" {}
variable "function_source_archive_bucket" {}
variable "function_source_archive_object" {}
variable "project" {}
variable "source_s3_data_bucket" {}

resource "google_cloudfunctions_function" "s3_create_event_trigger" {
  name = var.function_name
  description = var.function_description
  runtime = "python38"
  project = var.project

  available_memory_mb = 128
  source_archive_bucket = var.function_source_archive_bucket
  source_archive_object = var.function_source_archive_object
  entry_point = "main"
  #trigger_http = true
   
  event_trigger {
      event_type = "google.storage.object.finalize"
      resource = var.source_s3_data_bucket
  }
}