tflint {
  required_version = "~> 0.54.0"
}

plugin "terraform" {
  enabled = true
  preset  = "all"
}

plugin "aws" {
  enabled = true
  version = "0.36.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
  deep_check = true
}

rule "aws_resource_missing_tags" {
  enabled = true
  tags = [
    "env"
  ]
}
