variable "ami" {
  description = "ec2 ami id"
  type        = string
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "github_repo_token" {
  description = "GitHub PAT for cloning the private repository"
  type        = string
  sensitive   = true
}

variable "ghcr_pull_token" {
  description = "GitHub PAT for pulling private GHCR images"
  type        = string
  sensitive   = true
}

variable "backend_app_password" {
  description = "Application email password"
  type        = string
  sensitive   = true
}

variable "backend_jwt_secret" {
  description = "JWT signing secret"
  type        = string
  sensitive   = true
}

variable "backend_email" {
  description = "Email address used by the backend mail service"
  type        = string
  sensitive   = true
}