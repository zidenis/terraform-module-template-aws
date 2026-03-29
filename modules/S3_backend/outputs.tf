output "tfstate_bucket" {
  value       = aws_s3_bucket.tfstate_bucket.id
  description = "Name of the bucket that holds tfstate file."
}

output "tfstate_kms_key" {
  value       = aws_kms_key.tfstate_kms_key.id
  description = "KMS key to encrypt tfstate file."
}
