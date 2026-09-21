resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.public_az1.id
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name = "ecommerce-bastion"
  }
}

resource "aws_instance" "private" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.private_az1.id
  associate_public_ip_address = false

  root_block_device {
    volume_size           = 16
    volume_type           = "gp3"
    delete_on_termination = true
  }

  iam_instance_profile = aws_iam_instance_profile.ec2.name

  user_data = file("${path.module}/scripts/private-ec2-bootstrap.sh")

  vpc_security_group_ids = [aws_security_group.private.id]

  tags = {
    Name = "private-ec2"
  }
}