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
    Environment = "main_${locals.env_name}"
  }
}


resource "aws_security_group" "public_subnet" {
  name        = "public subnet web"
  description = "Allow http, https, ssh ports for public subnets"
  vpc_id      = module.vpc.default_vpc_id

  tags = {
    Name = "public_subnet_security_group"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.public_subnet.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}