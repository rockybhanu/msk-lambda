# Security Group for MSK Cluster
resource "aws_security_group" "msk_sg" {
  vpc_id = aws_vpc.ramanuj_vpc.id

  # Egress rule to allow MSK to respond to Lambda requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Ingress Rule to allow Lambda SG to access MSK on port 9098
resource "aws_security_group_rule" "msk_ingress_rule" {
  type                     = "ingress"
  from_port                = 9098
  to_port                  = 9098
  protocol                 = "tcp"
  security_group_id        = aws_security_group.msk_sg.id  # MSK SG
  source_security_group_id = aws_security_group.lambda_sg.id  # Lambda SG
}
