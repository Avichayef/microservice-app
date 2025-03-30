# Backend Configuration
# This configures Terraform to store state remotely in S3 with DynamoDB locking
# Note: This configuration will only work after running the bootstrap configuration

terraform {
  required_version = ">= 1.0.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Update to match provider.tf version
    }
  }

  backend "s3" {
    bucket         = "terraform-state-microservice-app"  # Must match state_bucket_name variable
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"                        # Must match aws_region variable
    dynamodb_table = "terraform-state-lock"             # Must match state_lock_table_name variable
    encrypt        = true
  }
}
