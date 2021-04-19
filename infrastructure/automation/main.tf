provider "google" {
  project = "rishu-gcp-project-20210414"
  region = "europe-west2"
  version = "~> 3.64"
  credentials = file("../../credentials/pipeline-g-infrastructure-editor.json")
}

module "storage" {
  source = "./core"
  bucket_name="rishu-gcp-project-20210414-bucket"
  bucket_region="EU"
}
