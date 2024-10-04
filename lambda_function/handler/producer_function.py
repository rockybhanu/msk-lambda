import os
import json
from kafka import KafkaProducer
from kafka.errors import KafkaError

# Lambda handler to produce messages to MSK using IAM authentication
def lambda_handler(event, context):
    # Get MSK brokers from environment variables
    msk_brokers = os.environ["MSK_BROKERS"]
    topic = "test_topic"  # Hardcoded topic name

    # Split the MSK brokers string into individual brokers
    brokers_list = msk_brokers.split(',')

    # Create an MSK Producer using IAM authentication
    producer = KafkaProducer(
        bootstrap_servers=brokers_list,  # Pass the list of brokers
        security_protocol="SASL_SSL",
        sasl_mechanism="AWS_MSK_IAM",
        sasl_plain_username=lambda: boto3.Session().get_credentials().access_key,
        sasl_plain_password=lambda: boto3.Session().get_credentials().secret_key,
    )

    # Send the incoming Lambda event (as a JSON payload) to the Kafka topic
    message = json.dumps(event)

    try:
        # Send message to the topic
        producer.send(topic, message.encode('utf-8'))
        producer.flush()

        return {
            'statusCode': 200,
            'body': json.dumps('Message sent to test_topic!')
        }

    except KafkaError as e:
        print(f"Failed to send message: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error sending message: {str(e)}')
        }
