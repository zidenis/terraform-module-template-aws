provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region

  # only allow the use of this AWS Account to prevent accidents.
  allowed_account_ids = [
    var.aws_account_id
  ]

  default_tags {
    tags = {
      env = var.env
    }
  }
}
