# VPC and Subnets
resource "aws_vpc" "ramanuj_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.ramanuj_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.ramanuj_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}