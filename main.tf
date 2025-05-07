locals {
  env_name = terraform.workspace
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "main_${locals.env_name}"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-3a", "eu-west-3b"]
  public_subnets  = ["10.0.1.0/24", "10.0.12.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]

  create_database_subnet_group = false
  enable_nat_gateway           = false

  tags = {
    Environment = "main"
  }
}

resource "aws_security_group" "public_subnet_egress" {
  name        = "HTTP_SSH"
  description = "Allow egress traffic"
  vpc_id      = module.vpc.default_vpc_id

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
  }

  tags = {
    Name = "Security group for public subnet egress"
  }
}