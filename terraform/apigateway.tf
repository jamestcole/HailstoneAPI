##############################################
# API Gateway → Lambda (Sync Hailstone API)
##############################################

# HTTP API
resource "aws_apigatewayv2_api" "hailstone_api" {
  name          = "${var.project_prefix}-api"
  protocol_type = "HTTP"
}

# Integration: API Gateway → Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.hailstone_api.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.hailstone_worker.invoke_arn
  payload_format_version = "2.0"
}

# Route: POST /hailstone
resource "aws_apigatewayv2_route" "hailstone_route" {
  api_id    = aws_apigatewayv2_api.hailstone_api.id
  route_key = "POST /hailstone"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# Stage
resource "aws_apigatewayv2_stage" "prod_stage" {
  api_id      = aws_apigatewayv2_api.hailstone_api.id
  name        = "prod"
  auto_deploy = true
}

# Allow API Gateway to call Lambda
resource "aws_lambda_permission" "apigw_invoke" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hailstone_worker.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.hailstone_api.execution_arn}/*/*"
}

##############################################
# API Outputs
##############################################

output "api_endpoint" {
  value = "${aws_apigatewayv2_api.hailstone_api.api_endpoint}/prod/hailstone"
}
