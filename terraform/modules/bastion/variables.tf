variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "allowed_ip" {
  description = "CIDR block for allowed SSH access"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for bastion host"
  type        = string
  default     = "ami-0cff7528ff583bf9a"  # Amazon Linux 2
}

variable "instance_type" {
  description = "Instance type for bastion host"
  type        = string
  default     = "t3.micro"
}

variable "public_subnet_id" {
  description = "ID of public subnet for bastion host"
  type        = string
}

variable "key_name" {
  description = "Name of SSH key pair"
  type        = string
}

variable "instance_profile_name" {
  description = "Name of instance profile for bastion host"
  type        = string
}