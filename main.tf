module "backend" {
  source = "./modules/S3_backend"
  # Conditional use of S3 remote backend
  count          = var.use_s3_backend ? 1 : 0
  s3_bucket_name = var.tfstate_s3_bucket_name
}
