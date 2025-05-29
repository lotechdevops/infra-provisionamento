resource "aws_eip" "nat_eip" {

  tags = {
    Name = var.demo_nat_eip_name
  }

}

resource "aws_nat_gateway" "demo_natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.subnet_public_demo

  tags = {
    Name = var.natgateway_name
  }

  depends_on = [aws_eip.nat_eip]
}