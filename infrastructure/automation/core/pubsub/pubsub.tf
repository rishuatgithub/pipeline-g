
variable "project" {}
variable "pubsub_topic_name" {}
variable "pubsub_subscription_name" {}


resource "google_pubsub_topic" "pubsub_topic" {
  project = var.project
  name = var.pubsub_topic_name

  labels = {
    "key" = var.pubsub_topic_name
  }
}


resource "google_pubsub_subscription" "pubsub_subscription" {
  project = var.project
  name = var.pubsub_subscription_name
  topic = google_pubsub_topic.pubsub_topic.name

  message_retention_duration = "1200s"
  retain_acked_messages      = true
  ack_deadline_seconds       = "20"

  labels = {
    name = var.pubsub_subscription_name
  }

  expiration_policy {
    ttl = "300000.5s"
  }
}


output "pubsub_topic" {
  description = "Pub-Sub Topic Name"
  value = google_pubsub_topic.pubsub_topic.name
}

output "pubsub_subscription" {
  description = "Pub-Sub Subscription Name"
  value = google_pubsub_subscription.pubsub_subscription.name
}