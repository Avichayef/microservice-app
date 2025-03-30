# Architecture Overview

```mermaid
graph TB
    subgraph "AWS Cloud"
        subgraph "VPC"
            subgraph "Public Subnet"
                ALB[Application Load Balancer]
                BASTION[Bastion Host]
                NAT[NAT Gateway]
            end
            
            subgraph "Private Subnet"
                ECS[ECS Fargate Cluster]
                subgraph "Container Services"
                    FRONTEND[Frontend Service]
                    BACKEND[Backend Service]
                    FLUENTBIT[Fluent Bit Sidecar]
                end
                RDS[RDS Database]
            end
        end
        
        subgraph "Security & Monitoring"
            WAF[WAF]
            SECRETS[Secrets Manager]
            CW[CloudWatch]
            SNS[SNS Alerts]
        end
        
        subgraph "CI/CD"
            GITHUB[GitHub Actions]
            ECR[ECR Repository]
        end
    end
    
    GITHUB -->|Push Images| ECR
    ECR -->|Pull Images| ECS
    ALB -->|Route Traffic| FRONTEND
    FRONTEND -->|API Calls| BACKEND
    BACKEND -->|Database Queries| RDS
    WAF -->|Protect| ALB
    FLUENTBIT -->|Ship Logs| CW
    CW -->|Trigger| SNS
    BASTION -->|Admin Access| RDS