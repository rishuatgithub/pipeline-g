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


### for function: fileupload_event_service_metadata

data "archive_file" "fileupload_event_service_metadata_zip"{
  type = "zip"
  source_dir = "${path.root}/../../app/fileupload_event_service_metadata"
  output_path = "${path.root}/../../app/generated/fileupload_event_service_metadata.zip"
}

resource "google_storage_bucket_object" "archive" {
  name   = "${data.archive_file.fileupload_event_service_metadata_zip.output_md5}.zip"
  bucket = module.app_storage.bucket_name
  source = "${path.root}/../../app/generated/fileupload_event_service_metadata.zip"
}

module "file_upload_event_service_metadata_cfunction" {
  source = "./core/cloud_function"
  function_name = "${var.location}-fileupload_event_service_metadata"
  function_description="Cloud function for fileupload_event_service_metadata"
  project=var.project
  function_source_archive_bucket=module.app_storage.bucket_name
  function_source_archive_object=google_storage_bucket_object.archive.name
  source_s3_data_bucket=module.landing_storage.bucket_name
}

### for function: fileupload_event_service_read_pubsub

data "archive_file" "fileupload_event_service_read_pubsub_zip"{
  type = "zip"
  source_dir = "${path.root}/../../app/fileupload_event_service_read_pubsub"
  output_path = "${path.root}/../../app/generated/fileupload_event_service_read_pubsub.zip"
}

resource "google_storage_bucket_object" "pubsub_data_archive" {
  name   = "${data.archive_file.fileupload_event_service_read_pubsub_zip.output_md5}.zip"
  bucket = module.app_storage.bucket_name
  source = "${path.root}/../../app/generated/fileupload_event_service_read_pubsub.zip"
}

module "fileupload_event_service_read_pubsub_cfunction" {
  source = "./core/cloud_function"
  function_name = "${var.location}-fileupload_event_service_read_pubsub"
  function_description="Cloud function for fileupload_event_service_read_pubsub"
  project=var.project
  function_source_archive_bucket=module.app_storage.bucket_name
  function_source_archive_object=google_storage_bucket_object.pubsub_data_archive.name
  source_s3_data_bucket=module.landing_storage.bucket_name
}



### create pubsub topic and upload the file event

module "file_upload_event_service_data_pubsub" {
  source = "./core/pubsub"
  project = var.project
  pubsub_topic_name = "${var.location}-${var.file_upload_event_service}-data-topic"
  pubsub_subscription_name = "${var.location}-${var.file_upload_event_service}-data-subscription"
}

module "file_upload_event_service_firestore" {
  source = "./core/firestore"
  project = var.project
  collection = "${var.location}-${var.file_upload_event_service}-collection"
  document_id = "${var.location}-${var.file_upload_event_service}-document01"
  fields = "{}"
}