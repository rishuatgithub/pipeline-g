#data "google_iam_policy" "admin" {
#  binding {
#    role = "roles/iam.serviceAccountUser"

#    members = [
#     "user:jane@example.com",
#    ]
#  }
#}

#resource "google_service_account" "pipeline_g_resource" {
#  account_id = "pipeline-g-gcp-resource"
#  display_name = "Service Account for accessing gcp project resources"
#}

