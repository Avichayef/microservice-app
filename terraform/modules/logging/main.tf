resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/aws/ecs/${var.project_name}"
  retention_in_days = var.retention_days

  tags = {
    Name = "${var.project_name}-logs"
  }
}

output "log_bucket_id" {
  description = "ID of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.app_logs.name
}