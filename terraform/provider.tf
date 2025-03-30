# AWS Provider Configuration
# This configures the AWS Provider with our desired region and default tags
# that will be applied to all resources created by Terraform.

provider "aws" {
  region = var.aws_region
  
  # Default tags are automatically applied to all resources that support tagging
  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      ManagedBy   = "Terraform"
      LastUpdated = timestamp()
    }
  }
}
