module "landing_storage" {
  source = "./core/storage"
  bucket_name="${var.project}-${var.location}-landing-bucket"
  bucket_region=var.location
}

module "app_storage" {
  source = "./core/storage"
  bucket_name="${var.project}-${var.location}-app-bucket"
  bucket_region=var.location
}

data "archive_file" "trigger_function_file_metadata_zip"{
  type = "zip"
  source_dir = "${path.root}/../../app/s3_trigger_file_metadata"
  output_path = "${path.root}/../../app/generated/s3_trigger_file_metadata.zip"
}

resource "google_storage_bucket_object" "archive" {
  name   = "${data.archive_file.trigger_function_file_metadata_zip.output_md5}.zip"
  bucket = module.app_storage.bucket_name
  source = "${path.root}/../../app/generated/s3_trigger_file_metadata.zip"
}

module "file_upload_event_service_cfunction" {
  source = "./core/cloud_function"
  function_name = "${var.project}-${var.location}-s3-trigger-file-metadata"
  function_description="Cloud function for s3-trigger-file-metadata"
  project=var.project
  function_source_archive_bucket=module.app_storage.bucket_name
  function_source_archive_object=google_storage_bucket_object.archive.name
  source_s3_data_bucket=module.landing_storage.bucket_name
}

module "file_upload_event_service_pubsub" {
  source = "./core/pubsub"
  project = var.project
  pubsub_topic_name = "${var.file_upload_event_service}-topic"
  pubsub_subscription_name = "${var.file_upload_event_service}-subscription"
}