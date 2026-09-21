resource "aws_cloudwatch_log_group" "ecommerce_ec2" {
  name              = "/ecommerce/ec2"
  retention_in_days = 7
}