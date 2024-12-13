#!/bin/bash

AWS_CLI_INSTALLED=$(which aws)
[[ $? -ne 0 ]] && echo "AWS CLI not found" && exit 0

GREP_COLORS="never"
AWS_PROFILE="default"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --profile ${AWS_PROFILE})
sed "s/#AWS_ACCOUNT_ID/${AWS_ACCOUNT_ID}/" terraform.tfvars.sample > terraform.tfvars
terraform -chdir=modules/S3_backend init | grep -i "initialized"
terraform -chdir=modules/S3_backend apply -auto-approve -var-file="../../terraform.tfvars" | grep -E "(^Apply|will be created)"
TFSTATE_BUCKET=$(terraform -chdir=modules/S3_backend output -raw tfstate_bucket)
TFSTATE_KMS_KEY=$(terraform -chdir=modules/S3_backend output -raw tfstate_kms_key)
TFSTATE_LOCK_TABLE=$(terraform -chdir=modules/S3_backend output -raw tfstate_lock_table)
sed -i "s/#TFSTATE_BUCKET/${TFSTATE_BUCKET}/" terraform.tfvars
terraform import module.backend[0].aws_kms_key.tfstate_kms_key ${TFSTATE_KMS_KEY} | grep "Import "
terraform import module.backend[0].aws_s3_bucket.tfstate_bucket ${TFSTATE_BUCKET} | grep "Import "
terraform import module.backend[0].aws_s3_bucket_lifecycle_configuration.tfstate_bucket_lifecycle ${TFSTATE_BUCKET}  | grep "Import "
terraform import module.backend[0].aws_s3_bucket_public_access_block.tfstate_bucket_access ${TFSTATE_BUCKET}  | grep "Import "
terraform import module.backend[0].aws_s3_bucket_server_side_encryption_configuration.tfstate_bucket_encryption ${TFSTATE_BUCKET} | grep "Import "
terraform import module.backend[0].aws_s3_bucket_versioning.tfstate_bucket_versioning ${TFSTATE_BUCKET} | grep "Import "
terraform import module.backend[0].aws_dynamodb_table.tfstate_lock_table ${TFSTATE_LOCK_TABLE}  | grep "Import "
AWS_REGION="$(terraform output -raw aws_region)"
cat > backend.tf << HEREDOC
terraform {
  backend "s3" {
    bucket = "${TFSTATE_BUCKET}"
    key = "terraform.tfstate"
    region = "${AWS_REGION}"
    dynamodb_table = "${TFSTATE_LOCK_TABLE}"
  }
}
HEREDOC
terraform init -migrate-state -force-copy | grep "backend"
