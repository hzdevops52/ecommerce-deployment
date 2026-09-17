resource "aws_cloudwatch_metric_alarm" "ec2_high_memory" {
  alarm_name          = "high_memory_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "mem_used_percent"
  namespace           = "Ecommerce/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "alarm on high memory of ec2"
  alarm_actions       = [aws_sns_topic.ecommerce_alerts.arn]
}


resource "aws_cloudwatch_metric_alarm" "ec2_high_disk" {

  alarm_name = "high_disk_alarm"

  comparison_operator = "GreaterThanOrEqualToThreshold"

  evaluation_periods = 2

  metric_name = "disk_used_percent"

  namespace = "Ecommerce/EC2"

  period = 60

  statistic = "Average"

  threshold = 80

  alarm_description = "Alarm on high disk usage of EC2"

  alarm_actions = [aws_sns_topic.ecommerce_alerts.arn]

}