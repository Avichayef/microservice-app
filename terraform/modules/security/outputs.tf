output "ecs_task_execution_role_arn" {
  description = "ARN of ECS task execution role"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "ecs_task_role_arn" {
  description = "ARN of ECS task role"
  value       = aws_iam_role.ecs_task.arn
}

output "bastion_instance_profile_name" {
  description = "Name of bastion host instance profile"
  value       = aws_iam_instance_profile.bastion.name
}

output "waf_acl_arn" {
  description = "ARN of the WAF ACL"
  value       = aws_wafv2_web_acl.main.arn
}
