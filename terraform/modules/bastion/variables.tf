variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where bastion will be created"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID for bastion host"
  type        = string
}

variable "bastion_ami_id" {
  description = "AMI ID for bastion host"
  type        = string
  default     = null  # Will be looked up if not provided
}

variable "instance_type" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key name for bastion access"
  type        = string
}

variable "allowed_ip" {
  description = "IP address allowed to connect to bastion"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name for bastion"
  type        = string
}
