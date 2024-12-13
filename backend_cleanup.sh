#!/bin/bash

terraform -chdir=modules/S3_backend destroy -auto-approve
rm -rf modules/S3_backend/.terraform
rm -f modules/S3_backend/terraform.tfstate
rm -f modules/S3_backend/terraform.tfstate.backup
rm -f modules/S3_backend/.terraform.lock.hcl
rm -rf .terraform
rm -f backend.tf
rm -f terraform.tfstate
rm -f terraform.tfstate.backup
rm -f terraform.tfvars
rm -f .terraform.lock.hcl
