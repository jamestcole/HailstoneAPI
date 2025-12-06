##############################################
# Outputs for the full Hailstone API stack
##############################################

output "sqs_queue_url" {
  description = "URL of the main SQS queue"
  value       = module.sqs.queue_url
}

output "sqs_queue_arn" {
  description = "ARN of the main SQS queue"
  value       = module.sqs.queue_arn
}

output "lambda_worker_arn" {
  description = "Lambda worker ARN"
  value       = module.lambda.lambda_arn
}

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = module.dynamodb.table_name
}

output "api_invoke_url" {
  description = "Invoke URL for hailstone API endpoint"
  value       = module.api_gateway.api_endpoint
}
