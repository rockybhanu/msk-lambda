# IAM Role for Lambda to authenticate with MSK
resource "aws_iam_role" "lambda_msk_role" {
  name = "lambda-msk-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach Policy for Lambda to access MSK using IAM and manage VPC Network Interfaces
resource "aws_iam_role_policy" "lambda_msk_policy" {
  role = aws_iam_role.lambda_msk_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kafka-cluster:Connect",
          "kafka-cluster:DescribeCluster",
          "kafka-cluster:DescribeClusterV2",
          "kafka-cluster:GetBootstrapBrokers",
          "kafka-cluster:AlterCluster",
          "kafka-cluster:CreateCluster",
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:CreateTopic",
          "kafka-cluster:DeleteTopic",
          "kafka-cluster:WriteData",
          "kafka-cluster:ReadData",
          "kafka-cluster:AlterTopic",
          "kafka-cluster:DescribeGroup",
          "kafka-cluster:AlterGroup",
          "kafka-cluster:ListTopics",
          "kafka-cluster:ListClusters",
          "kafka-cluster:ListGroups",
          "kafka-cluster:DescribeNode",
          "kafka-cluster:AlterCluster",
          "kafka-cluster:DescribeConfiguration",
          "kafka-cluster:DescribeConfigurationRevision"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        Resource = "*"
      }
    ]
  })
}

