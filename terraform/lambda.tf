##############################################
# Lambda Worker for Hailstone Processing
##############################################

# Package Lambda code from local directory
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.root}/lambda"  # terraform/lambda/
  output_path = "${path.root}/lambda.zip"
}

# IAM Role for Lambda execution
resource "aws_iam_role" "lambda_role" {
  name = "${var.project_prefix}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Basic execution policy (CloudWatch Logs)
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_role.name
}

# Custom inline policy: DynamoDB access
resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.project_prefix}-lambda-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "dynamodb:GetItem",
          "dynamodb:PutItem"
        ],
        Resource = aws_dynamodb_table.hailstone_results.arn
      }
    ]
  })
}

# Lambda function resource
resource "aws_lambda_function" "hailstone_worker" {
  function_name = "${var.project_prefix}-worker"
  handler       = "handler.handler"
  runtime       = "python3.12"

  role     = aws_iam_role.lambda_role.arn
  filename = data.archive_file.lambda_zip.output_path

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  timeout     = 30
  memory_size = 256

  environment {
    variables = {
      TABLE_NAME = "${var.project_prefix}-results"
    }
  }
}
