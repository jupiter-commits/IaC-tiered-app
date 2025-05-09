locals {
  key_name         = "developer-key-1"
  eu_west_3_ami    = "ami-0b198a85d03bfa122"
}

resource "aws_key_pair" "developer" {
  key_name   = local.key_name
  public_key = var.public_key_1
  }
