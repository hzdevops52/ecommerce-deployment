#elastic IP
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "ecommerce-nat-eip"
  }
}

resource "aws_nat_gateway" "public" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_az1.id

  depends_on = [aws_internet_gateway.ecommerce_gateway]

  tags = {
    Name = "ecommerce-nat-gateway"
  }
}