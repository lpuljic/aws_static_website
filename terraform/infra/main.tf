provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Static Website"
      Environment = "prototype"
      Owner       = "Lano Puljic"
    }
  }
}

# Random string generator, this will append random string at the end of the resource.
# This will help to not cause conflicts with naming.
resource "random_string" "this" {
  length  = 10
  lower   = true
  upper   = false
  numeric = true
  special = false
}

data "aws_caller_identity" "current" {}
