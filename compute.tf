locals {
  key_name         = "developer-key-1"
  eu_west_3_ami    = "ami-0b198a85d03bfa122"
}

resource "aws_key_pair" "developer" {
  key_name   = local.key_name
  public_key = var.public_key_1
  }

resource "aws_instance" "public_server" {
  ami             = locals.eu_west_3_ami
  instance_type   = var.instance_type
  subnet_id       = module.vpc.public_subnets[0]
  security_groups = [aws_security_group.public_subnet.name]
  key_name        = local.key_name

  user_data                   = file("ec2-deploy.sh")
  user_data_replace_on_change = true

  tags = {
    Name = "Public EC2 server"
  }
}
