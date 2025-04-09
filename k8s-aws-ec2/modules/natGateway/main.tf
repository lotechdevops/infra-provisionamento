resource "aws_eip" "nat_eip" {

  tags = {
    Name = var.k8s_nat_eip_name 
  }

}

resource "aws_nat_gateway" "k8s_natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_ids[0]

  tags = {
    Name = var.natgateway_name
  }

  depends_on = [aws_eip.nat_eip]
}