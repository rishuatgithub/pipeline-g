module "storage" {
  source = "./core"
  bucket_name="${var.project}-${var.location}-data-bucket"
  bucket_region=var.location
}

module "processed-storage" {
  source = "./core"
  bucket_name="${var.project}-${var.location}-processed-bucket"
  bucket_region=var.location
}