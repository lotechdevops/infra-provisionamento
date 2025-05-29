resource "aws_route_table" "public" {
  vpc_id = var.vpc_demo_id

  route {
    cidr_block = var.cidr_rt_public
    gateway_id = var.demo_igw_id
  }
  tags = {
    Name = var.rt_public_name
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = var.public_subnet_ids
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_demo_id

  route {
    cidr_block     = var.cidr_rt_private
    nat_gateway_id = var.demo_nat_gateway_id
  }
  tags = {
    Name = var.rt_private_name
  }
}
resource "aws_route_table_association" "private" {
  subnet_id      = var.private_subnet_ids
  route_table_id = aws_route_table.private.id
}