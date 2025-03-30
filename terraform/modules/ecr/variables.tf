variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "allowed_account_ids" {
  description = "List of AWS account IDs allowed to pull images"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags for ECR repositories"
  type        = map(string)
  default     = {}
}