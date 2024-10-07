resource "aws_msk_configuration" "custom_config" {
  name              = "custom-config"
  kafka_versions    = ["3.6.0"] # Ensure this matches your cluster Kafka version
  server_properties = <<PROPERTIES
auto.create.topics.enable = true
delete.topic.enable = true
allow.everyone.if.no.acl.found = false
PROPERTIES
}
