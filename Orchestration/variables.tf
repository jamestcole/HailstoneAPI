##############################################
# Global Variables for Hailstone API
##############################################

# Which AWS region to deploy into
variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "eu-west-1"
}

# Prefix used for naming SQS, Lambda, DynamoDB resources
variable "project_prefix" {
  description = "Resource name prefix for Hailstone API infrastructure"
  type        = string
  default     = "hailstone-api"
}
