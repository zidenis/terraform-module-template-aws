terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.42.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.3"
    }
  }

  required_version = "~> 1.14.9"
}
