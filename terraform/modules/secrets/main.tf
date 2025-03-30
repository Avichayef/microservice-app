# Add KMS key for secrets encryption
resource "aws_kms_key" "secrets" {
  description             = "KMS key for Secrets Manager"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# Secrets Manager Module

resource "aws_secretsmanager_secret" "app_secrets" {
  name                = "${var.project_name}-app-secrets"
  kms_key_id         = aws_kms_key.secrets.id
  recovery_window_in_days = 7

  tags = {
    Name = "${var.project_name}-app-secrets"
  }
}

# Initial secret version with placeholder values
resource "aws_secretsmanager_secret_version" "app_secrets" {
  secret_id = aws_secretsmanager_secret.app_secrets.id
  
  secret_string = jsonencode({
    DATABASE_URL      = var.database_url
    API_KEY          = var.api_key
    JWT_SECRET       = var.jwt_secret
    # Add other secrets as needed
  })
}

# IAM Policy document for secret access
data "aws_iam_policy_document" "secret_access" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]
    resources = [aws_secretsmanager_secret.app_secrets.arn]
  }
}

# IAM Policy for accessing this secret
resource "aws_iam_policy" "secret_access" {
  name        = "${var.project_name}-secret-access-policy"
  description = "Policy for accessing application secrets"
  policy      = data.aws_iam_policy_document.secret_access.json
}

# Add resource policy
resource "aws_secretsmanager_secret_policy" "secret_policy" {
  secret_arn = aws_secretsmanager_secret.app_secrets.arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "EnableECSAccess"
        Effect = "Allow"
        Principal = {
          AWS = var.ecs_task_role_arn
        }
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = aws_secretsmanager_secret.app_secrets.arn
      }
    ]
  })
}
