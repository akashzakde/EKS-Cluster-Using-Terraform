resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  /*
  enable_classiclink = false
  enable_classiclink_dns_support = false
  assign_generated_ipv6_cidr_black = false
*/

  tags = {
    Name = "main"
  }
}

output "vpc_id" {
  description = "ID of project VPC"
  value       = aws_vpc.main.id
}