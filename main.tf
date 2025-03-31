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
  tags = {
    Name = "Public subnet 1"
  }
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
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "ELastic IP for NAT Gateway"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip_ngw
  subnet_id = aws_subnet.public_1

  tags = {
    Name = "NAT Gateway"
  }
}

resource "aws_route_table" "route_public_subnet" {
  vpc_id = aws_vpc.main_vpc

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Route table for public subnet"
  }
}

resource "aws_route_table_association" "route_public_association" {
  subnet_id = aws_subnet.public_1.id
  route_table_id = aws_route_table.route_public_subnet.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main_vpc

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Route table for private subnet"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "public_subnet" {
  name = "HTTP_SSH"
  description = "Allow ports 80, 443, 22"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  
  tags = {
    Name = "Secrity group for public subnet HTTP and SSH"
  }
}
