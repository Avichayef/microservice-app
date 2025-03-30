resource "aws_ecs_task_definition" "app" {
  family                   = "${var.project_name}-app"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = var.task_cpu
  memory                  = var.task_memory
  execution_role_arn      = aws_iam_role.ecs_execution.arn
  task_role_arn          = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name  = "frontend"
      image = "${var.container_image}:${var.container_tag}"
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awsfirelens"
        options = {
          Name       = "cloudwatch"
          region     = var.aws_region
          log_group_name = "/ecs/${var.project_name}/frontend"
          log_stream_prefix = "frontend"
          auto_create_group = "true"
        }
      }
    },
    {
      name  = "fluent-bit"
      image = "public.ecr.aws/aws-observability/aws-for-fluent-bit:latest"
      firelensConfiguration = {
        type = "fluentbit"
        options = {
          "enable-ecs-log-metadata" = "true"
        }
      }
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.project_name}/fluent-bit"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "fluent-bit"
        }
      }
      memoryReservation = 50
    }
  ])
}
