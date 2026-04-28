tflint {
  required_version = "~> 0.62.0"
}

plugin "terraform" {
  enabled = true
  preset  = "all"
}

plugin "aws" {
  enabled = true
  version = "0.47.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
  # deep checking e precisa de credenciais AWS para validar recursos contra a AWS.
  # Habilite se estiver com credenciais válidas e precisar de validação mais rigorosa
  deep_check = false
}

rule "aws_resource_missing_tags" {
  enabled = true
  tags = [
    "env"
  ]
}
