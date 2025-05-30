# Criar Elastic IPs para os NAT Gateways
resource "aws_eip" "nat_eip" {
  count = var.nat_gateway_count

  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = var.nat_gateway_count > 1 ? "${var.demo_nat_eip_name}-${count.index + 1}" : var.demo_nat_eip_name
      Type = "NAT Gateway EIP"
    }
  )
}

# Criar NAT Gateways
resource "aws_nat_gateway" "demo_natgw" {
  count = var.nat_gateway_count

  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = var.subnet_public_demo[count.index]

  tags = merge(
    var.tags,
    {
      Name   = var.nat_gateway_count > 1 ? "${var.natgateway_name}-${count.index + 1}" : var.natgateway_name
      Type   = "NAT Gateway"
      Subnet = var.subnet_public_demo[count.index]
    }
  )
}