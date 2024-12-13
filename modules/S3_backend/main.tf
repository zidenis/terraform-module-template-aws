# tfsec:ignore:aws-s3-enable-logging
resource "aws_s3_bucket" "tfstate_bucket" {
  #checkov:skip=CKV_AWS_18:no need of bucket access logging
  #checkov:skip=CKV2_AWS_62:no need of bucket event notifications
  #checkov:skip=CKV_AWS_144:no need of cross-region replication
  bucket = local.bucket_name

  force_destroy = var.force_destroy

  tags = {
    Description = var.description
    env         = var.env
  }
}

resource "aws_s3_bucket_versioning" "tfstate_bucket_versioning" {
  bucket = aws_s3_bucket.tfstate_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "tfstate_kms_key" {
  #checkov:skip=CKV2_AWS_64:A default KMS key policy will be used.
  # The default key policy effectively delegates all access control to IAM policies and KMS grants.
  description             = "Key used to encrypt tfstate"
  enable_key_rotation     = true
  rotation_period_in_days = 365 # number between 90 and 2560
  # After the waiting period ends, AWS KMS deletes the KMS key.
  # Value must be between 7 and 30. Default is 30.
  deletion_window_in_days            = 7
  bypass_policy_lockout_safety_check = false

  tags = {
    env = var.env
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate_bucket_encryption" {
  bucket = aws_s3_bucket.tfstate_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.tfstate_kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Enforces the block of all public access
resource "aws_s3_bucket_public_access_block" "tfstate_bucket_access" {
  bucket = aws_s3_bucket.tfstate_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "tfstate_bucket_lifecycle" {
  #checkov:skip=CKV_AWS_300:no need of abort_incomplete_multipart_upload
  bucket = aws_s3_bucket.tfstate_bucket.id

  depends_on = [aws_s3_bucket_versioning.tfstate_bucket_versioning]

  rule {
    id = "tfstate_transition_and_expiration"
    filter {} # applies to all objects in the bucket
    status = "Enabled"

    noncurrent_version_transition {
      noncurrent_days = var.transition_days
      storage_class   = var.transition_storage_class
    }

    noncurrent_version_expiration {
      newer_noncurrent_versions = var.expiration_versions
      noncurrent_days           = var.expiration_days
    }
  }
}

# tfsec:ignore:aws-dynamodb-table-customer-key
# tfsec:ignore:aws-dynamodb-enable-recovery
resource "aws_dynamodb_table" "tfstate_lock_table" {
  #checkov:skip=CKV_AWS_28:no need for PITR
  #checkov:skip=CKV_AWS_119:no need for DynamoDB Tables with encryption with KMS CMK
  name         = "${aws_s3_bucket.tfstate_bucket.id}-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "${aws_s3_bucket.tfstate_bucket.id}-lock-table"
    env  = var.env
  }
}
