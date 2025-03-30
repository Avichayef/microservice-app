#!/bin/bash
set -e

# Check if state bucket exists
if ! aws s3 ls "s3://terraform-state-microservice-app" 2>&1 > /dev/null; then
    echo "Bootstrap state bucket not found. Creating bootstrap resources..."
    
    # Run bootstrap Terraform
    cd terraform/bootstrap
    terraform init
    terraform apply -auto-approve
    
    echo "Bootstrap complete. State bucket and DynamoDB table created."
else
    echo "Bootstrap resources already exist. Proceeding with main deployment."
fi