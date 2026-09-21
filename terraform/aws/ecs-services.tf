###############################################################################
# FRONTEND ECS SERVICE
###############################################################################

resource "aws_ecs_service" "frontend" {
  name            = "ecommerce-frontend"
  cluster         = aws_ecs_cluster.ecommerce.id
  task_definition = aws_ecs_task_definition.frontend.arn

  desired_count = 1
  launch_type   = "FARGATE"

  network_configuration {
    subnets = [
      aws_subnet.private_az1.id,
      aws_subnet.private_az2.id
    ]

    security_groups = [
      aws_security_group.ecs_frontend.id
    ]

    assign_public_ip = false
  }

  # Register frontend tasks with the ECS ALB
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_frontend.arn
    container_name   = "frontend"
    container_port   = 80
  }
}


###############################################################################
# BACKEND ECS SERVICE
###############################################################################

resource "aws_ecs_service" "backend" {
  name            = "ecommerce-backend"
  cluster         = aws_ecs_cluster.ecommerce.id
  task_definition = aws_ecs_task_definition.backend.arn

  desired_count = 1
  launch_type   = "FARGATE"

  network_configuration {
    subnets = [
      aws_subnet.private_az1.id,
      aws_subnet.private_az2.id
    ]

    security_groups = [
      aws_security_group.ecs_backend.id
    ]

    assign_public_ip = false
  }

  # Register backend tasks with private DNS service discovery
  service_registries {
    registry_arn = aws_service_discovery_service.backend.arn
  }
}


###############################################################################
# MONGODB ECS SERVICE
###############################################################################

resource "aws_ecs_service" "mongodb" {
  name            = "ecommerce-mongodb"
  cluster         = aws_ecs_cluster.ecommerce.id
  task_definition = aws_ecs_task_definition.mongodb.arn

  desired_count = 1
  launch_type   = "FARGATE"

  network_configuration {
    subnets = [
      aws_subnet.private_az1.id,
      aws_subnet.private_az2.id
    ]

    security_groups = [
      aws_security_group.ecs_mongodb.id
    ]

    assign_public_ip = false
  }

  # Register MongoDB with private DNS service discovery
  service_registries {
    registry_arn = aws_service_discovery_service.mongodb.arn
  }
}