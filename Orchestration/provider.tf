##############################################
# Provider + Backend Configuration
##############################################

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Use AWS CLI credentials by default
provider "aws" {
  region = var.aws_region
}
