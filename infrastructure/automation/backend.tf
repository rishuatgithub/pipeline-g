terraform {
  backend "gcs" {
    bucket  = "tf-backend-state"
    prefix  = "terraform/state"
    credentials = "../../credentials/pipeline-g-infrastructure-editor.json"
  }
}