resource "aws_msk_cluster" "msk_cluster" {
  cluster_name           = "ramanuj-msk-cluster"
  kafka_version          = "2.6.1"
  number_of_broker_nodes = 2

  broker_node_group_info {
    instance_type   = "kafka.m5.large"
    client_subnets  = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
    security_groups = [aws_security_group.msk_sg.id]
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS" # Enable TLS
      in_cluster    = true
    }
  }

  client_authentication {
    sasl {
      iam = true # Enable IAM access control
    }
  }
  configuration_info {
    arn      = aws_msk_configuration.custom_config.arn
    revision = aws_msk_configuration.custom_config.latest_revision
  }
}
