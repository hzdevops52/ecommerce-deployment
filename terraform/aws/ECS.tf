resource "aws_ecs_cluster" "ecommerce" {
  name = "ecommerce_cluster"

  tags = {
    Name = "ecommerce_cluster"
  }
}