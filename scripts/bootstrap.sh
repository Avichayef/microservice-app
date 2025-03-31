#!/bin/bash
set -e

# Get the absolute path of the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

echo "Starting bootstrap process..."

# Get GitHub repository information from git config
GITHUB_REPO_URL=$(git config --get remote.origin.url)
GITHUB_ORG=$(echo $GITHUB_REPO_URL | sed -n 's/.*github.com[:/]\([^/]*\).*/\1/p')
GITHUB_REPO=$(echo $GITHUB_REPO_URL | sed -n 's/.*github.com[:/][^/]*\/\([^.]*\).*/\1/p')

# Run bootstrap Terraform
cd "$PROJECT_ROOT/terraform/bootstrap"

# Use the full path to terraform
/usr/local/bin/terraform init
/usr/local/bin/terraform apply -auto-approve \
  -var="github_org=$GITHUB_ORG" \
  -var="github_repo=$GITHUB_REPO"

echo "Bootstrap process completed successfully!"
