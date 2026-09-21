terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "http" "my_ip" {
  url = "https://checkip.amazonaws.com/"
}