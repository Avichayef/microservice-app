# IAM policy for GitHub Actions role
resource "aws_iam_role_policy" "github_actions" {
  name = "github-actions-terraform-policy"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:DescribeKey",
          "kms:ListKeys",
          "kms:GetKeyPolicy",
          "sns:GetTopicAttributes",
          "wafv2:GetWebACL",
          "guardduty:GetDetector",
          "acm:DescribeCertificate",
          "acm:ListCertificates"
        ]
        Resource = "*"
      }
    ]
  })
}

# GitHub Actions IAM role
resource "aws_iam_role" "github_actions" {
  name = "github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
        }
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:sub": "repo:${var.github_org}/${var.github_repo}:*"
          }
        }
      }
    ]
  })
}
