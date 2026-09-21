###############################################################################
# ALB Security Group
###############################################################################

resource "aws_security_group" "alb" {
  name        = "ecommerce-alb-sg"
  description = "Security group for ecommerce Application Load Balancer"
  vpc_id      = aws_vpc.ecommerce_vpc.id

  ingress {
    description = "Allow HTTP from the internet"
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
    Name = "ecommerce-alb-sg"
  }
}

###############################################################################
# Allow ALB to reach the private EC2 frontend NodePort
###############################################################################

resource "aws_vpc_security_group_ingress_rule" "private_ec2_from_alb" {
  security_group_id            = aws_security_group.private.id
  referenced_security_group_id = aws_security_group.alb.id

  from_port   = 30081
  to_port     = 30081
  ip_protocol = "tcp"

  description = "Allow ALB to reach frontend NodePort on private EC2"
}

###############################################################################
# Application Load Balancer
###############################################################################

resource "aws_lb" "ecommerce" {
  name               = "ecommerce-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.public_az1.id,
    aws_subnet.public_az2.id
  ]

  enable_deletion_protection = false

  tags = {
    Name = "ecommerce-alb"
  }
}

###############################################################################
# Target Group
###############################################################################

resource "aws_lb_target_group" "ecommerce" {
  name        = "ecommerce-tg"
  port        = 30081
  protocol    = "HTTP"
  target_type = "instance"

  vpc_id = aws_vpc.ecommerce_vpc.id

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/"
    port                = "30081"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name = "ecommerce-tg"
  }
}

###############################################################################
# Register private EC2 with Target Group
###############################################################################

resource "aws_lb_target_group_attachment" "private_ec2" {
  target_group_arn = aws_lb_target_group.ecommerce.arn
  target_id        = aws_instance.private.id
  port             = 30081
}

###############################################################################
# ALB HTTP Listener
###############################################################################

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ecommerce.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecommerce.arn
  }
}