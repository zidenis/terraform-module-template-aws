# Terraform Module: S3 Bucket for Terraform State Files

This Terraform module provisions an S3 bucket to store Terraform state files securely, ensuring best practices for encryption, versioning, and lifecycle management. It also creates a DynamoDB table for state locking and consistency.

## Features

- Creates an S3 bucket with:
  - Server-side encryption using a KMS key
  - Versioning enabled
  - Lifecycle rules for noncurrent object transition and expiration
  - Blocked public access for enhanced security
- Creates a DynamoDB table for state locking
- Configurable through input variables

## Resources Created

- **S3 Bucket**: Stores Terraform state files with server-side encryption, versioning, and lifecycle rules.
- **KMS Key**: Encrypts objects in the S3 bucket.
- **DynamoDB Table**: Enables state locking and consistency for Terraform operations.
