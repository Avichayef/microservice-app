output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.main.arn  # Changed from "app" to "main"
}

output "security_group_id" {
  description = "ID of the ALB security group"
  value       = aws_security_group.alb.id
}

output "alb_arn_suffix" {
  description = "ARN suffix of the ALB"
  value       = aws_lb.main.arn_suffix
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_lb.main.arn
}
