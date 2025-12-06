/terraform
│
├── main.tf                # Calls the modules or glue components
├── variables.tf           # All variables
├── outputs.tf             # Outputs for Lambda ARN, API URL, etc.
│
├── sqs.tf                 # SQS queue + DLQ
├── lambda.tf              # Lambda + IAM role/policies + code packaging
├── dynamodb.tf            # Table for caching results
├── apigateway.tf          # API Gateway integration + routes
│
└── provider.tf            # AWS provider + region