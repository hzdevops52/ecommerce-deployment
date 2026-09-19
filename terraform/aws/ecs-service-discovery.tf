###############################################################################
# PRIVATE DNS NAMESPACE
###############################################################################

resource "aws_service_discovery_private_dns_namespace" "ecommerce" {
  name = "ecommerce.local"

  vpc = aws_vpc.ecommerce_vpc.id

  description = "Private DNS namespace for ecommerce ECS services"
}


###############################################################################
# MONGODB SERVICE DISCOVERY
###############################################################################

resource "aws_service_discovery_service" "mongodb" {
  name = "mongodb"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.ecommerce.id

    dns_records {
      type = "A"
      ttl  = 10
    }

    routing_policy = "MULTIVALUE"
  }
}


###############################################################################
# BACKEND SERVICE DISCOVERY
###############################################################################

resource "aws_service_discovery_service" "backend" {
  name = "backend"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.ecommerce.id

    dns_records {
      type = "A"
      ttl  = 10
    }

    routing_policy = "MULTIVALUE"
  }
}