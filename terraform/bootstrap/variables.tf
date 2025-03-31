# Bootstrap Variables
# These variables are used specifically for the bootstrap configuration

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state storage"
  type        = string
  default     = "terraform-state-microservice-app"
}

variable "state_lock_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "terraform-state-lock"
}
