variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "database_url" {
  description = "Database connection string"
  type        = string
  sensitive   = true
}

variable "api_key" {
  description = "API key for external services"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "Secret for JWT token signing"
  type        = string
  sensitive   = true
}

variable "ecs_task_role_arn" {
  description = "ARN of the ECS task role that needs access to the secrets"
  type        = string
}
