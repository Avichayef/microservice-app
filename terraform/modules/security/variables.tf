variable "project_name" {
  description = "Name of the project, used for resource naming"
  type        = string
}

variable "secrets_arn" {
  description = "ARN of the secrets in Secrets Manager"
  type        = string
}