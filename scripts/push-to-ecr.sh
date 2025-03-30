#!/bin/bash

# Script: push-to-ecr.sh
# Purpose: Build and push Docker images to Amazon ECR
# 
# Required environment variables:
# - AWS_REGION: Target AWS region
# - AWS_ACCOUNT_ID: AWS account ID
# - PROJECT_NAME: Project identifier for ECR repository names

# Exit on any error
set -e

# Check required environment variables
for var in AWS_REGION AWS_ACCOUNT_ID PROJECT_NAME; do
    if [ -z "${!var}" ]; then
        echo "Error: $var environment variable is not set"
        exit 1
    fi
done

# Function to handle errors
error_handler() {
    echo "Error occurred in script at line: $1"
    exit 1
}

trap 'error_handler ${LINENO}' ERR

ECR_REGISTRY="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com"

echo "Logging into ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_REGISTRY

for service in frontend backend; do
    echo "Building and pushing $service image..."
    
    # Build the image
    docker build \
        --no-cache \
        --pull \
        -t $ECR_REGISTRY/${PROJECT_NAME}-${service}:latest \
        -t $ECR_REGISTRY/${PROJECT_NAME}-${service}:$(date +%Y%m%d_%H%M%S) \
        ./${service}

    # Push all tags
    docker push --all-tags $ECR_REGISTRY/${PROJECT_NAME}-${service}
done

echo "Image push completed successfully!"
