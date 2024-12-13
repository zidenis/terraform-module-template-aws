output "tfstate_bucket" {
  value       = one(module.backend[*].tfstate_bucket)
  description = "The name used for the terraform state bucket."
}

output "aws_region" {
  value       = var.aws_region
  description = "Region used for the terraform state bucket."
}
