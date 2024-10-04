# Lambda Function with IAM Auth for MSK
resource "aws_lambda_function" "produce_message_lambda" {
  function_name = "produce_message_to_msk"
  role          = aws_iam_role.lambda_msk_role.arn
  runtime       = "python3.12"
  handler       = "handler.producer_function.lambda_handler"  # Correct handler path
  filename      = "${path.module}/lambda_function/lambda.zip" # Correct path to the ZIP file
  timeout       = 300
  environment {
    variables = {
      MSK_BROKERS = aws_msk_cluster.msk_cluster.bootstrap_brokers_sasl_iam
      MSK_TOPIC   = "data_topic" # Replace with your Kafka topic name
    }
  }

  vpc_config {
    subnet_ids         = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}
