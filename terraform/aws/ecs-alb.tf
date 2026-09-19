###############################################################################
# ECS APPLICATION LOAD BALANCER
###############################################################################

resource "aws_security_group" "ecs_alb" {
  name        = "ecommerce-ecs-alb-sg"
  description = "Security group for ECS Application Load Balancer"
  vpc_id      = aws_vpc.ecommerce_vpc.id

  ingress {
    description = "Allow HTTP from internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecommerce-ecs-alb-sg"
  }
}


###############################################################################
# ECS APPLICATION LOAD BALANCER
###############################################################################

resource "aws_lb" "ecs" {
  name               = "ecommerce-ecs-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.ecs_alb.id
  ]

  subnets = [
    aws_subnet.public_az1.id,
    aws_subnet.public_az2.id
  ]

  enable_deletion_protection = false

  tags = {
    Name = "ecommerce-ecs-alb"
  }
}


###############################################################################
# FRONTEND TARGET GROUP
###############################################################################

resource "aws_lb_target_group" "ecs_frontend" {
  name        = "ecommerce-ecs-frontend-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

  vpc_id = aws_vpc.ecommerce_vpc.id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    port                = "80"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name = "ecommerce-ecs-frontend-tg"
  }
}


###############################################################################
# HTTP LISTENER
###############################################################################

resource "aws_lb_listener" "ecs_http" {
  load_balancer_arn = aws_lb.ecs.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_frontend.arn
  }
}