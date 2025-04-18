# Root module - Orchestrates all child modules
#
# This configuration sets up:
# - Networking (VPC, subnets)
# - Container Registry (ECR)
# - ECS Cluster and Services
# - Application Load Balancer
# - Security Groups and IAM Roles
# - Secrets Management

data "aws_caller_identity" "current" {}

locals {
  github_org  = "your-org-name"    # Same as in github_oidc module
  github_repo = "your-repo-name"   # Same as in github_oidc module
}

module "networking" {
  source = "./modules/networking"

  project_name         = var.project_name
  aws_region          = var.aws_region
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

# New ECR module for container repositories
module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  allowed_account_ids = var.allowed_account_ids
}

module "secrets" {
  source = "./modules/secrets"

  project_name      = var.project_name
  database_url      = var.database_url
  api_key           = var.api_key
  jwt_secret        = var.jwt_secret
  ecs_task_role_arn = module.security.ecs_task_role_arn
}

module "security" {
  source = "./modules/security"

  project_name   = var.project_name
  secrets_arn    = module.secrets.secret_arn
  aws_account_id = data.aws_caller_identity.current.account_id
  github_org     = local.github_org
  github_repo    = local.github_repo
}

module "bastion" {
  source = "./modules/bastion"

  project_name         = var.project_name
  vpc_id              = module.networking.vpc_id
  public_subnet_id    = module.networking.public_subnet_ids[0]
  allowed_ip          = var.bastion_allowed_ip
  key_name            = var.ssh_key_name
  instance_profile_name = aws_iam_instance_profile.bastion.name
}

module "alb" {
  source = "./modules/alb"

  project_name      = var.project_name
  vpc_id           = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  certificate_arn   = var.certificate_arn
  container_port    = var.backend_port
  health_check_path = "/health"
  log_bucket        = module.logging.log_bucket_id
  allowed_cidr_blocks = ["0.0.0.0/0"]  # Consider restricting this in production
}

module "logging" {
  source = "./modules/logging"

  project_name = var.project_name
  retention_days = var.log_retention_days
}

module "ecs" {
  source = "./modules/ecs"

  project_name          = var.project_name
  aws_region           = var.aws_region
  vpc_id               = module.networking.vpc_id
  private_subnet_ids   = module.networking.private_subnet_ids
  alb_security_group_id = module.alb.security_group_id
  alb_target_group_arn = module.alb.target_group_arn
  
  container_image      = module.ecr.backend_repository_url
  container_port       = var.backend_port
  
  task_cpu            = var.task_cpu
  task_memory         = var.task_memory
  service_desired_count = var.service_desired_count
  container_tag       = var.container_tag
  
  ecs_task_role_arn   = module.security.ecs_task_role_arn
  ecs_task_execution_role_arn = module.security.ecs_task_execution_role_arn
  
  container_environment = [
    {
      name  = "ENVIRONMENT"
      value = var.environment
    }
  ]
  
  container_secrets = [
    {
      name      = "DATABASE_URL"
      valueFrom = "${module.secrets.secret_arn}:DATABASE_URL::"
    },
    {
      name      = "JWT_SECRET"
      valueFrom = "${module.secrets.secret_arn}:JWT_SECRET::"
    }
  ]
}

module "github_oidc" {
  source = "./modules/github-oidc"

  project_name              = var.project_name
  github_org               = "your-org-name"
  github_repo              = "your-repo-name"
  terraform_state_bucket_arn = "arn:aws:s3:::${var.state_bucket_name}"
  terraform_lock_table_arn   = "arn:aws:dynamodb:::table/${var.state_lock_table_name}"
}

module "monitoring" {
  source = "./modules/monitoring"

  project_name     = var.project_name
  ecs_cluster_name = module.ecs.cluster_name
  ecs_service_name = module.ecs.service_name
  alb_arn_suffix   = module.alb.alb_arn_suffix
}
