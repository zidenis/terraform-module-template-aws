variable "description" {
  type        = string
  default     = "S3 Bucket to store terraform state"
  description = "A description for the terraform S3 bucket."
}

# A Random bucket name that will be used if var s3_bucket_name is not defined.
resource "random_id" "random_bucket_name" {
  count       = var.s3_bucket_name == null ? 1 : 0
  byte_length = 4
  prefix      = "tfstate-"
}

locals {
  bucket_name = coalesce(var.s3_bucket_name, one(random_id.random_bucket_name[*].hex))
}

variable "s3_bucket_name" {
  type        = string
  description = "The name to use for the S3 bucket that holds the tfstate file."
  default     = null
}

variable "force_destroy" {
  type        = bool
  description = "Indicates if all tfstate bucket objects should be deleted when the bucket is destroyed."
  default     = true
}

variable "transition_days" {
  type        = number
  description = "Number of days after which noncurrent versions of tfstate file will be transitioned to other storage class."
  default     = 30 # Must be >= 30 for storageClass 'ONEZONE_IA'
}

variable "transition_storage_class" {
  type        = string
  description = "Class of storage used to store the noncurrent versions of tfstate file after transition_days."
  default     = "ONEZONE_IA"
}

variable "expiration_days" {
  type        = number
  description = "Number of days after which an noncurrent tfstate file will be expired."
  default     = 60
}

variable "expiration_versions" {
  type        = number
  description = "Number of noncurrent versions of tfstate files to be retained after expiration_days."
  default     = 5
}

variable "env" {
  type        = string
  description = "Name of the environment."
  default     = "undefined"
}
