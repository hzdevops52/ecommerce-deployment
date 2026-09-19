###############################################################################
# ECS TASK EXECUTION ROLE
#
# This role is used by ECS/Fargate itself, not by the application container.
#
# It allows ECS to:
# - Pull private images from Amazon ECR
# - Send container logs to CloudWatch
# - Retrieve secrets from AWS services when configured
###############################################################################

resource "aws_iam_role" "ecs_task_execution" {
  name = "ecommerce-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "ecommerce-ecs-task-execution-role"
  }
}


###############################################################################
# AWS MANAGED ECS EXECUTION POLICY
#
# Provides the standard permissions required for:
# - ECR image pulling
# - CloudWatch Logs
# - ECS task execution
###############################################################################

resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role = aws_iam_role.ecs_task_execution.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

###############################################################################
# SSM PARAMETER ACCESS
#
# Allows ECS/Fargate to retrieve the backend secrets from
# AWS Systems Manager Parameter Store.
###############################################################################

resource "aws_iam_role_policy" "ecs_ssm_access" {
  name = "ecommerce-ecs-ssm-access"
  role = aws_iam_role.ecs_task_execution.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter"
        ]

        Resource = [
          aws_ssm_parameter.backend_app_password.arn,
          aws_ssm_parameter.backend_jwt_secret.arn
        ]
      }
    ]
  })
}