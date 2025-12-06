##############################################
# Terraform Main Configuration Entry Point
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

provider "aws" {
  region = var.aws_region
}

##############################################
# Core Components for Hailstone API
##############################################

# SQS Queue for buffering jobs
module "sqs" {
  source = "./sqs.tf"
}

# DynamoDB table for caching results
module "dynamodb" {
  source = "./dynamodb.tf"
}

# Lambda worker to process Hailstone logic
module "lambda" {
  source      = "./lambda.tf"
  queue_arn   = module.sqs.queue_arn
  table_name  = module.dynamodb.table_name
}

# API Gateway that receives requests and enqueues to SQS
module "api_gateway" {
  source       = "./apigateway.tf"
  queue_url    = module.sqs.queue_url
}
