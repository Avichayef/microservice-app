# Deployment Guide

## Prerequisites
- AWS Account
- AWS CLI installed and configured
- Terraform v1.0.0+
- Docker installed
- Node.js v18+
- GitHub account with repository access

## Initial Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/your-org/your-repo.git
   cd your-repo
   ```

2. Configure AWS credentials:
   ```bash
   aws configure
   ```

3. Add required GitHub secret:
   - Go to repository Settings > Secrets and Variables > Actions
   - Add `AWS_ACCOUNT_ID` with your 12-digit AWS account ID

## Local Testing

1. Test frontend:
   ```bash
   cd frontend
   npm install
   npm test
   ```

2. Test backend:
   ```bash
   cd backend
   npm install
   npm test
   ```

3. Test local deployment:
   ```bash
   docker-compose up
   ```
   Access:
   - Frontend: http://localhost:3000
   - Backend: http://localhost:4000

## Infrastructure Deployment

1. Bootstrap infrastructure (first time only):
   ```bash
   cd scripts
   chmod +x bootstrap.sh
   ./bootstrap.sh
   ```

2. Initialize Terraform:
   ```bash
   cd terraform
   terraform init
   ```

3. Plan and apply infrastructure:
   ```bash
   terraform plan -out=tfplan
   terraform apply tfplan
   ```

## CI/CD Pipeline

The pipeline automatically runs on:
- Push to main branch
- Pull request to main branch

Pipeline stages:
1. Tests
   - Frontend and backend unit tests
   - Security scanning (tfsec, hadolint)

2. Build & Push (main branch only)
   - Builds Docker images
   - Pushes to ECR with SHA tags

3. Infrastructure (main branch only)
   - Applies Terraform changes
   - Updates ECS services

4. Deployment (main branch only)
   - Zero-downtime deployment to ECS

## Manual Deployment

If needed, manually push images:
```bash
cd scripts
chmod +x push-to-ecr.sh
./push-to-ecr.sh
```

## Verification

1. Check AWS resources:
   ```bash
   # Get ALB DNS name
   terraform output alb_dns_name

   # Check ECS service status
   aws ecs describe-services \
     --cluster microservice-app-cluster \
     --services microservice-app-service
   ```

2. Monitor deployment:
   - AWS Console > ECS > Clusters > microservice-app-cluster
   - CloudWatch > Log groups > /aws/ecs/microservice-app

## Rollback

To rollback to previous version:
```bash
# Get previous task definition
aws ecs describe-task-definition \
  --task-definition microservice-app-app \
  --previous-revision

# Update service
aws ecs update-service \
  --cluster microservice-app-cluster \
  --service microservice-app-service \
  --task-definition microservice-app-app:<previous-revision>
```

## Security Notes

- All deployments use HTTPS
- Secrets are managed via AWS Secrets Manager
- Infrastructure changes require approval
- WAF protects the ALB
- All containers run as non-root