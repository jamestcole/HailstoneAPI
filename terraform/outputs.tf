##############################################
# Outputs for the Hailstone API stack
##############################################

output "api_invoke_url" {
  description = "Invoke URL for Hailstone API endpoint"
  value       = "${aws_apigatewayv2_api.hailstone_api.api_endpoint}/prod/hailstone"
}

output "lambda_worker_arn" {
  description = "Lambda worker ARN"
  value       = aws_lambda_function.hailstone_worker.arn
}

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = aws_dynamodb_table.hailstone_results.name
}
