terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc_example_simple" {
  source  = "terraform-aws-modules/vpc/aws//examples/simple"
  version = "5.19.0"

  name = "main_environment"
  cidr = "10.0.0.0/18"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.0.0/24"]
  private_subnets = ["10.0.1.0/24"]

  tags = {
    Environment = "main"
  }
}