output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = aws_instance.bastion.public_ip
}

output "bastion_private_ip" {
  description = "Private IP address of the bastion host"
  value       = aws_instance.bastion.private_ip
}

output "private_ec2_private_ip" {
  description = "Private IP address of the private EC2 instance"
  value       = aws_instance.private.private_ip
}

output "vpc_id" {
  description = "ID of the ecommerce VPC"
  value       = aws_vpc.ecommerce_vpc.id
}

output "nat_gateway_public_ip" {
  description = "Public IP address of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "alb_dns_name" {
  description = "DNS name of the ecommerce Application Load Balancer"
  value       = aws_lb.ecommerce.dns_name
}

output "alb_url" {
  description = "HTTP URL of the ecommerce application"
  value       = "http://${aws_lb.ecommerce.dns_name}"
}