provider "aws" {
  region = "us-east-1" # Change to your region
}

# VPC and Subnets
resource "aws_vpc" "msk_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.msk_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

# Security Group for MSK Cluster
resource "aws_security_group" "msk_sg" {
  vpc_id = aws_vpc.msk_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_msk_cluster" "msk_cluster" {
  cluster_name           = "my-msk-cluster"
  kafka_version          = "2.6.1"
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = "kafka.m5.large"
    client_subnets  = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
    security_groups = [aws_security_group.msk_sg.id]
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"  # Enable TLS
      in_cluster    = true
    }
  }

  client_authentication {
    sasl {
      iam = true  # Enable IAM access control
    }
  }
}


# IAM Role for Lambda to authenticate with MSK
resource "aws_iam_role" "lambda_msk_role" {
  name = "lambda-msk-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach Policy for Lambda to access MSK using IAM
resource "aws_iam_role_policy" "lambda_msk_policy" {
  role = aws_iam_role.lambda_msk_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeCluster",
          "kafka-cluster:AlterCluster",
          "kafka-cluster:AlterClusterMetrics"
        ],
        Resource = "*"
      }
    ]
  })
}

