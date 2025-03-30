# Core Variables
# These variables are used across multiple resources and modules

variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g., prod, staging, dev)"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Name of the project, used for resource naming and tagging"
  type        = string
  default     = "microservice-app"
}

# State Management Variables
variable "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state storage"
  type        = string
  default     = "terraform-state-microservice-app"  # This is the S3 bucket name
}

variable "state_lock_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "terraform-state-lock"  # This is the DynamoDB table name
}

# Tags Variables
variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "certificate_arn" {
  description = "ARN of ACM certificate for ALB HTTPS listener"
  type        = string
}

variable "container_tag" {
  description = "Tag for the container images"
  type        = string
  default     = "latest"
}

variable "task_cpu" {
  description = "Amount of CPU units to allocate to ECS task (256 = 0.25 vCPU)"
  type        = number
  default     = 256

  validation {
    condition     = contains([256, 512, 1024, 2048, 4096], var.task_cpu)
    error_message = "Task CPU must be one of: 256, 512, 1024, 2048, or 4096."
  }
}

variable "task_memory" {
  description = "Amount of memory (in MiB) to allocate to ECS task"
  type        = number
  default     = 512

  validation {
    condition     = var.task_memory >= 512 && var.task_memory <= 30720
    error_message = "Task memory must be between 512 MiB and 30720 MiB."
  }
}

variable "service_desired_count" {
  description = "Desired number of ECS tasks to run"
  type        = number
  default     = 2

  validation {
    condition     = var.service_desired_count > 0
    error_message = "Desired count must be greater than 0."
  }
}

variable "bastion_ami_id" {
  description = "AMI ID for the bastion host"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI ID - update as needed
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  type        = string
  default     = "t3.micro"
}

variable "app_port" {
  description = "Port on which the application runs"
  type        = number
  default     = 3000
}

variable "container_image" {
  description = "Docker image for the application"
  type        = string
}

variable "bastion_allowed_ip" {
  description = "CIDR block allowed to connect to bastion host"
  type        = string
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair for bastion host access"
  type        = string
}

variable "database_url" {
  description = "Database connection URL"
  type        = string
  sensitive   = true
}

variable "api_key" {
  description = "API key for external services"
  type        = string
  sensitive   = true
}

variable "jwt_secret" {
  description = "Secret for JWT token signing"
  type        = string
  sensitive   = true
}

variable "allowed_account_ids" {
  description = "List of AWS account IDs allowed to pull images from ECR"
  type        = list(string)
  default     = []
}

variable "backend_port" {
  description = "Port number for the backend service"
  type        = number
  default     = 4000
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
}

variable "ecs_task_role_arn" {
  description = "ARN of the ECS task role"
  type        = string
}

variable "enable_waf" {
  description = "Enable WAF for ALB"
  type        = bool
  default     = true
}

variable "enable_monitoring" {
  description = "Enable CloudWatch monitoring"
  type        = bool
  default     = true
}
