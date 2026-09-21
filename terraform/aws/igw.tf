resource "aws_internet_gateway" "ecommerce_gateway" {
  vpc_id = aws_vpc.ecommerce_vpc.id

  tags = {
    Name = "ecommerce-gateway"
  }
}
