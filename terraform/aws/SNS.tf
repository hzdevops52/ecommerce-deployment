resource "aws_sns_topic" "ecommerce_alerts" {
  name = "SNS-CLOUDWATCH-ALERTS"
}

resource "aws_sns_topic_subscription" "ecommerce_email" {
  topic_arn = aws_sns_topic.ecommerce_alerts.arn
  protocol  = "email"
  endpoint  = "hzdevops1@gmail.com"
}