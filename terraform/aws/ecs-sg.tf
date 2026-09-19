###############################################################################
# FRONTEND SECURITY GROUP
###############################################################################

resource "aws_security_group" "ecs_frontend" {
  name        = "ecommerce-ecs-frontend-sg"
  description = "Security group for ECS frontend"
  vpc_id      = aws_vpc.ecommerce_vpc.id

  ingress {
    description     = "Allow ECS ALB to reach frontend"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_alb.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecommerce-ecs-frontend-sg"
  }
}


###############################################################################
# BACKEND SECURITY GROUP
###############################################################################

resource "aws_security_group" "ecs_backend" {
  name        = "ecommerce-ecs-backend-sg"
  description = "Security group for ECS backend"
  vpc_id      = aws_vpc.ecommerce_vpc.id

  ingress {
    description     = "Allow frontend traffic to backend"
    from_port       = 5000
    to_port         = 5000
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_frontend.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecommerce-ecs-backend-sg"
  }
}


###############################################################################
# MONGODB SECURITY GROUP
###############################################################################

resource "aws_security_group" "ecs_mongodb" {
  name        = "ecommerce-ecs-mongodb-sg"
  description = "Security group for ECS MongoDB"
  vpc_id      = aws_vpc.ecommerce_vpc.id

  ingress {
    description     = "Allow MongoDB traffic from backend"
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_backend.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecommerce-ecs-mongodb-sg"
  }
}