variable "aws_region" {
    type = string
    default = "eu-west-3"  
}

variable "instance_type" {
    type = string
    default = "t2.micro"
    description = "EC2 instance type"
}