resource "aws_ssm_parameter" "github_repo_token" {
  name  = "/ecommerce/github/repo-token"
  type  = "SecureString"
  value = var.github_repo_token
}

resource "aws_ssm_parameter" "ghcr_pull_token" {
  name  = "/ecommerce/ghcr/pull-token"
  type  = "SecureString"
  value = var.ghcr_pull_token
}

resource "aws_ssm_parameter" "backend_app_password" {
  name  = "/ecommerce/backend/app-password"
  type  = "SecureString"
  value = var.backend_app_password
}

resource "aws_ssm_parameter" "backend_jwt_secret" {
  name  = "/ecommerce/backend/jwt-secret"
  type  = "SecureString"
  value = var.backend_jwt_secret
}