resource "aws_ecr_repository" "frontend" {
  name = "ecr_for_frontend"

  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "backend" {
  name = "ecr_for_backend"

  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}