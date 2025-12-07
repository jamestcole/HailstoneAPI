##############################################
# Global Variables for Hailstone API
##############################################

variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "eu-west-1"
}

variable "project_prefix" {
  description = "Resource name prefix for Hailstone API infrastructure"
  type        = string
  default     = "hailstone-api"
}

