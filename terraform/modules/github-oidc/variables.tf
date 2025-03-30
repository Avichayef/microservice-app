variable "project_name" {
  description = "Name of the project for resource naming"
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

variable "terraform_state_bucket_arn" {
  description = "ARN of the S3 bucket storing Terraform state"
  type        = string
}

variable "terraform_lock_table_arn" {
  description = "ARN of the DynamoDB table used for Terraform state locking"
  type        = string
}