##############################################
# DynamoDB Table for Result Caching
##############################################

resource "aws_dynamodb_table" "hailstone_results" {
  name         = "${var.project_prefix}-results"
  billing_mode = "PAY_PER_REQUEST" # Cost-effective, auto-scales
  hash_key     = "start"

  attribute {
    name = "start"
    type = "N"
  }

  tags = {
    Name = "${var.project_prefix}-dynamodb"
  }
}

##############################################
# Outputs from DynamoDB Module
##############################################

output "table_name" {
  value = aws_dynamodb_table.hailstone_results.name
}
