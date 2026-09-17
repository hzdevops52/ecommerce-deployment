data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

#AWS SYSTEMS MANAGER - PARAMETER STORE
data "aws_iam_policy_document" "ec2_ssm" {
  statement {
    effect  = "Allow"
    actions = ["ssm:GetParameter"]

    resources = [
      aws_ssm_parameter.github_repo_token.arn,
      aws_ssm_parameter.ghcr_pull_token.arn,
      aws_ssm_parameter.backend_app_password.arn,
      aws_ssm_parameter.backend_jwt_secret.arn
    ]
  }
}

resource "aws_iam_role" "ec2" {
  name        = "ecommerce-private-ec2-role"
  description = "IAM role for the private EC2 instance"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_policy" "ec2_ssm" {
  name        = "ecommerce-private-ec2-ssm"
  description = "Allow private EC2 to read ecommerce secrets from SSM"

  policy = data.aws_iam_policy_document.ec2_ssm.json
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.ec2_ssm.arn
}

resource "aws_iam_instance_profile" "ec2" {
  name = "ecommerce-private-ec2-profile"
  role = aws_iam_role.ec2.name
}

#cloudwatch
resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_agent" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# CloudWatch verification
data "aws_iam_policy_document" "ec2_cloudwatch_read" {
  statement {
    effect = "Allow"

    actions = [
      "cloudwatch:ListMetrics",
      "cloudwatch:GetMetricData",
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:DescribeAlarms"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "ec2_cloudwatch_read" {
  name        = "ecommerce-private-ec2-cloudwatch-read"
  description = "Allow EC2 to verify CloudWatch metrics and alarms"

  policy = data.aws_iam_policy_document.ec2_cloudwatch_read.json
}

resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_read" {
  role       = aws_iam_role.ec2.name
  policy_arn = aws_iam_policy.ec2_cloudwatch_read.arn
}