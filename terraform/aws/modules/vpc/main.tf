resource "aws_vpc" "vpc_k8s" {
  cidr_block           = var.vpcCidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}