###############################################################################
# FRONTEND TASK DEFINITION
###############################################################################

resource "aws_ecs_task_definition" "frontend" {
  family                   = "ecommerce-frontend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  cpu    = "256"
  memory = "512"

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "${aws_ecr_repository.frontend.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = {
    Name = "ecommerce-frontend-task"
  }
}


###############################################################################
# BACKEND TASK DEFINITION
###############################################################################

resource "aws_ecs_task_definition" "backend" {
  family                   = "ecommerce-backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  cpu    = "256"
  memory = "512"

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "${aws_ecr_repository.backend.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 5000
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "NAME"
          value = "ecommerce"
        },
        {
          name  = "EMAIL"
          value = var.backend_email
        },
        {
          name  = "MONGO_URI"
          value = "mongodb://mongodb.ecommerce.local:27017/ecommerce"
        },
        {
          name  = "REACT_APP_FRONTEND_URL"
          value = "http://${aws_lb.ecs.dns_name}"
        }
      ]

      secrets = [
        {
          name      = "APP_PASSWORD"
          valueFrom = aws_ssm_parameter.backend_app_password.arn
        },
        {
          name      = "JWT_SECRET"
          valueFrom = aws_ssm_parameter.backend_jwt_secret.arn
        }
      ]

      healthCheck = {
        command = [
          "CMD-SHELL",
          "wget --spider -q http://localhost:5000/health || exit 1"
        ]
        interval    = 10
        timeout     = 5
        retries     = 5
        startPeriod = 30
      }
    }
  ])

  tags = {
    Name = "ecommerce-backend-task"
  }
}


###############################################################################
# MONGODB TASK DEFINITION
###############################################################################

resource "aws_ecs_task_definition" "mongodb" {
  family                   = "ecommerce-mongodb"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  cpu    = "256"
  memory = "512"

  container_definitions = jsonencode([
    {
      name      = "mongodb"
      image     = "mongo:6"
      essential = true

      portMappings = [
        {
          containerPort = 27017
          protocol      = "tcp"
        }
      ]

      healthCheck = {
        command = [
          "CMD-SHELL",
          "mongosh --eval \"db.adminCommand('ping')\" || exit 1"
        ]
        interval    = 10
        timeout     = 5
        retries     = 5
        startPeriod = 30
      }
    }
  ])

  tags = {
    Name = "ecommerce-mongodb-task"
  }
}