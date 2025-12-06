##############################################
# API Gateway → SQS (Async job submission)
##############################################

# Create HTTP API
resource "aws_apigatewayv2_api" "hailstone_api" {
  name          = "${var.project_prefix}-api"
  protocol_type = "HTTP"
}

# Create IAM role so API Gateway can send SQS messages
resource "aws_iam_role" "apigw_sqs_role" {
  name = "${var.project_prefix}-apigw-sqs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Action    = "sts:AssumeRole",
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy allowing API Gateway to send messages to SQS queue
resource "aws_iam_role_policy" "apigw_sqs_policy" {
  name = "${var.project_prefix}-apigw-sqs-policy"
  role = aws_iam_role.apigw_sqs_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "sqs:SendMessage"
        ],
        Resource = var.queue_arn
      }
    ]
  })
}

# Integration: API Gateway → SQS
resource "aws_apigatewayv2_integration" "sqs_integration" {
  api_id                 = aws_apigatewayv2_api.hailstone_api.id
  integration_type       = "AWS_PROXY"
  integration_subtype    = "SQS-SendMessage"
  payload_format_version = "1.0"

  credentials_arn = aws_iam_role.apigw_sqs_role.arn

  request_parameters = {
    "QueueUrl"    = var.queue_url
    "MessageBody" = "$request.body"
  }
}

# Route: POST /hailstone
resource "aws_apigatewayv2_route" "hailstone_route" {
  api_id    = aws_apigatewayv2_api.hailstone_api.id
  route_key = "POST /hailstone"
  target    = "integrations/${aws_apigatewayv2_integration.sqs_integration.id}"
}

# API Deployment + Stage
resource "aws_apigatewayv2_stage" "prod_stage" {
  api_id      = aws_apigatewayv2_api.hailstone_api.id
  name        = "prod"
  auto_deploy = true

  tags = {
    Name = "${var.project_prefix}-stage"
  }
}

##############################################
# API Outputs
##############################################

output "api_endpoint" {
  value = "${aws_apigatewayv2_api.hailstone_api.api_endpoint}/prod/hailstone"
}
