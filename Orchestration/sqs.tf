##############################################
# SQS Queue for Hailstone Job Processing
##############################################

resource "aws_sqs_queue" "hailstone_dlq" {
  name = "${var.project_prefix}-dlq"

  message_retention_seconds = 1209600 # 14 days
}

resource "aws_sqs_queue" "hailstone_queue" {
  name = "${var.project_prefix}-queue"

  visibility_timeout_seconds = 60     # Lambda processing time (tune later)
  message_retention_seconds = 86400   # 1 day

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.hailstone_dlq.arn
    maxReceiveCount     = 5           # retry before dead-lettering
  })
}

##############################################
# Outputs from SQS Module
##############################################

output "queue_url" {
  value = aws_sqs_queue.hailstone_queue.url
}

output "queue_arn" {
  value = aws_sqs_queue.hailstone_queue._
