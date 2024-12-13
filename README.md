# Terraform Module Template for AWS Resources

This template serves as a foundation for creating Terraform modules to provision AWS resources.

### Features

- Creates an S3 bucket to store terraform state with:
  - Server-side encryption using a KMS key
  - Versioning enabled
  - Lifecycle rules for noncurrent object transition and expiration
  - Blocked public access for enhanced security
- Creates a DynamoDB table for state locking
- Configurable through input variables

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.80.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_backend"></a> [backend](#module\_backend) | ./modules/S3_backend | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS Account ID. | `string` | n/a | yes |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | Name of the AWS profile. | `string` | `"default"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS Region. | `string` | `"us-east-1"` | no |
| <a name="input_env"></a> [env](#input\_env) | Name of the environment. | `string` | `"undefined"` | no |
| <a name="input_tfstate_s3_bucket_name"></a> [tfstate\_s3\_bucket\_name](#input\_tfstate\_s3\_bucket\_name) | The name to use for the S3 bucket that holds the tfstate file. | `string` | `null` | no |
| <a name="input_use_s3_backend"></a> [use\_s3\_backend](#input\_use\_s3\_backend) | Whether to use a S3 bucket as backend for tfstate file. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_region"></a> [aws\_region](#output\_aws\_region) | Region used for the terraform state bucket. |
| <a name="output_tfstate_bucket"></a> [tfstate\_bucket](#output\_tfstate\_bucket) | The name used for the terraform state bucket. |
<!-- END_TF_DOCS -->
