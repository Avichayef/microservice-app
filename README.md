# Microservice Infrastructure Project

This project implements a secure, scalable infrastructure for running microservices on AWS using ECS, with complete CI/CD pipeline and monitoring.

## Architecture

```ascii
                                     ┌──────────────┐
                                     │   GitHub     │
                                     │   Actions    │
                                     └──────┬───────┘
                                           │
                                           ▼
                        ┌─────────────────────────────────────┐
                        │            AWS Cloud                 │
                        │                                     │
┌──────────┐           │  ┌──────────┐      ┌────────────┐   │
│  GitHub  │─────OIDC──┼─▶│   IAM    │      │    ECR     │   │
└──────────┘           │  └──────────┘      └────────────┘   │
                       │        │                  ▲          │
                       │        ▼                  │          │
┌──────────┐          │  ┌──────────┐      ┌────────────┐   │
│ Internet │──────────┼─▶│   WAF    │─────▶│    ALB     │   │
└──────────┘          │  └──────────┘      └─────┬──────┘   │
                      │                           │          │
                      │  ┌──────────┐      ┌─────▼──────┐   │
                      │  │ Secrets  │◄─────│    ECS     │   │
                      │  │ Manager  │      │            │   │
                      │  └──────────┘      └─────┬──────┘   │
                      │                           │          │
                      │  ┌──────────┐      ┌─────▼──────┐   │
                      │  │CloudWatch│◄─────│  Logging   │   │
                      │  │          │      │            │   │
                      │  └──────────┘      └────────────┘   │
                      └─────────────────────────────────────┘
```

## Prerequisites

- AWS Account
- GitHub Account
- AWS CLI installed and configured
- Terraform installed (v1.0.0+)
- Docker installed

## Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-org/your-repo.git
   cd your-repo
   ```

2. **Configure AWS Credentials**
   ```bash
   aws configure
   ```

3. **Set up GitHub Secrets**
   - Go to your GitHub repository settings
   - Navigate to Secrets and Variables > Actions
   - Add the following secret:
     - Name: `AWS_ACCOUNT_ID`
     - Value: Your 12-digit AWS account ID

4. **Initialize Terraform**
   ```bash
   cd terraform
   terraform init
   ```

5. **Deploy Infrastructure**
   ```bash
   terraform plan
   terraform apply
   ```

6. **Verify Deployment**
   - Check AWS Console for created resources
   - Verify GitHub Actions workflow is running

## Security Features

- OIDC authentication for GitHub Actions
- WAF protection for ALB
- Secrets management using AWS Secrets Manager
- CloudWatch monitoring and alerts
- Least privilege IAM policies
- Container image scanning
- Infrastructure security scanning

## Monitoring and Logging

- ECS container logs in CloudWatch
- Application metrics in CloudWatch
- Custom CloudWatch dashboards
- Automated alerts for:
  - High CPU/Memory usage
  - HTTP 5XX errors
  - Application errors

## CI/CD Pipeline

The pipeline automatically:
1. Runs unit tests
2. Performs security scans
3. Builds and pushes Docker images
4. Deploys infrastructure changes
5. Updates ECS services

## Directory Structure

```
.
├── terraform/
│   ├── modules/
│   │   ├── ecs/
│   │   ├── monitoring/
│   │   ├── networking/
│   │   └── security/
│   ├── main.tf
│   └── variables.tf
├── .github/
│   └── workflows/
│       └── main.yml
├── docker-compose.yml
└── README.md
```