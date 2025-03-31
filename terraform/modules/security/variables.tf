variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "secrets_arn" {
  description = "ARN of the secrets manager secret"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "github_org" {
  description = "GitHub organization name"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}
