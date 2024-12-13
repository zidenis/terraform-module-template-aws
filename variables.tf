variable "aws_account_id" {
  type        = string
  description = "AWS Account ID."
}

variable "aws_profile" {
  type        = string
  description = "Name of the AWS profile."
  default     = "default"
}

variable "aws_region" {
  type        = string
  description = "AWS Region."
  default     = "us-east-1"
}

variable "env" {
  type        = string
  description = "Name of the environment."
  default     = "undefined"
}

variable "use_s3_backend" {
  type        = bool
  description = "Whether to use a S3 bucket as backend for tfstate file."
  default     = false
}

variable "tfstate_s3_bucket_name" {
  type        = string
  description = "The name to use for the S3 bucket that holds the tfstate file."
  default     = null
}
