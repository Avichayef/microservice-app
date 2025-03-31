#!/bin/bash
set -e

# Get the absolute path of the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

echo "Starting bootstrap process..."

# Check AWS CLI configuration
if ! aws sts get-caller-identity &>/dev/null; then
    echo "Error: AWS CLI not configured. Please run 'aws configure' first."
    exit 1
fi

# Check if state bucket exists
if ! aws s3 ls "s3://terraform-state-microservice-app" 2>&1 > /dev/null; then
    echo "Bootstrap state bucket not found. Creating bootstrap resources..."
    
    # Run bootstrap Terraform
    cd "$PROJECT_ROOT/terraform/bootstrap"
    
    # Initialize Terraform
    terraform init
    
    # Apply Terraform configuration
    terraform apply -auto-approve
    
    echo "Bootstrap complete. State bucket and DynamoDB table created."
else
    echo "Bootstrap resources already exist. Proceeding with main deployment."
fi

echo "Bootstrap process completed successfully!"
