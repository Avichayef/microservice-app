output "secret_arn" {
  description = "ARN of the created secret"
  value       = aws_secretsmanager_secret.app_secrets.arn
}

output "secret_access_policy_arn" {
  description = "ARN of the IAM policy for accessing the secret"
  value       = aws_iam_policy.secret_access.arn
}