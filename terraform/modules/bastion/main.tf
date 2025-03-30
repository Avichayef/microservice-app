# Bastion Host Module

# Security Group for Bastion
resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  # SSH access from allowed IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ip]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-bastion-sg"
  }
}

# Bastion Host
resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.bastion.id]
  iam_instance_profile   = var.instance_profile_name

  root_block_device {
    volume_size = 20
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required" # IMDSv2
  }

  tags = {
    Name = "${var.project_name}-bastion"
  }

  # User data script for hardening
  user_data = <<-EOF
              #!/bin/bash
              # Update system
              yum update -y
              
              # Configure SSH hardening
              sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
              sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
              
              # Enable and configure audit logging
              yum install -y audit
              systemctl enable auditd
              systemctl start auditd
              
              # Install AWS CLI and SSM Agent
              yum install -y aws-cli amazon-ssm-agent
              systemctl enable amazon-ssm-agent
              systemctl start amazon-ssm-agent
              EOF
}

# CloudWatch Log Group for Bastion
resource "aws_cloudwatch_log_group" "bastion" {
  name              = "/aws/bastion/${var.project_name}"
  retention_in_days = 30

  tags = {
    Name = "${var.project_name}-bastion-logs"
  }
}

# Add missing variable defaults
variable "ami_id" {
  description = "AMI ID for the bastion host"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"  # Amazon Linux 2 AMI ID
}

variable "instance_type" {
  description = "Instance type for the bastion host"
  type        = string
  default     = "t3.micro"
}
