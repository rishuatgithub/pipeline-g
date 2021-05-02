variable "project" {}
variable "collection" {}
variable "document_id" {}
variable "fields" {}

resource "google_firestore_document" "firestore" {
  project = var.project
  collection = var.collection
  document_id = var.document_id
  fields = var.fields
}