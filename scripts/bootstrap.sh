#!/bin/bash
set -e

# Get the absolute path of the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

echo "Current directory: $(pwd)"
echo "Script directory: $SCRIPT_DIR"
echo "Project root: $PROJECT_ROOT"
echo "Terraform version: $(terraform version)"

# Get GitHub repository information
GITHUB_REPO_URL=$(git config --get remote.origin.url)
GITHUB_ORG=$(echo $GITHUB_REPO_URL | sed -n 's/.*github.com[:/]\([^/]*\).*/\1/p')
GITHUB_REPO=$(echo $GITHUB_REPO_URL | sed -n 's/.*github.com[:/][^/]*\/\([^.]*\).*/\1/p')

echo "Running Terraform bootstrap..."
cd "$PROJECT_ROOT/terraform/bootstrap"
echo "Changed to directory: $(pwd)"

terraform init
terraform apply -auto-approve \
  -var="github_org=$GITHUB_ORG" \
  -var="github_repo=$GITHUB_REPO"

echo "Bootstrap process completed successfully!"
