
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"

  name = "main_environment"
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