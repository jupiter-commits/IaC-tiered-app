 terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
 }

 provider "aws" {
  region = "us-east-1" #$
 }


resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main_vpc"
  }
}

resource "aws_subnet" "aws_subnet_public" {
  cidr_block = "10.0.0.0/24"
  vpc_id = aws_vpc.main_vpc.id
  tags = {Name = "Public subnet"}
}

