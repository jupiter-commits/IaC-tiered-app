 terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
 }

 provider "aws" {
  region = "us-east-1"
 }


resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main_vpc"
  }
}

resource "aws_subnet" "public_1" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.main_vpc.id
  tags = {Name = "Public subnet 1"}
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "Internet Gateway"
  }
}

resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Private subnet 1"
  }
}

resource "aws_eip" "eip_ngw" {
  vpc = true
  depends_on = [aws_internet_gateway.igw_1]
  tags = {
    Name = "ELastic IP for NAT Gateway"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip_ngw_1
  subnet_id = aws_subnet.aws_subnet_public

  tags = {
    Name = "NAT Gateway"
  }
}
