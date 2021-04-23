provider "google" {
  project = var.project
  region = var.region
  credentials = file(var.credentials)
  
  version = "~> 3.64"
}