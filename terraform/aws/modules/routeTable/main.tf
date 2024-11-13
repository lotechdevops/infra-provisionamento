resource "aws_route_table" "rt_public" {
  vpc_id = var.vpc_k8s

  route {
    cidr_block = var.cidr_rt_public
    gateway_id = var.igw_name
  }

  tags = {
    Name = var.rt_public_name
  }

}

resource "aws_route_table_association" "rt_public_association" {
  route_table_id = aws_route_table.rt_public.id
  subnet_id      = var.subnet_public
}

resource "aws_route_table" "rt_private" {
  vpc_id = var.vpc_k8s

  route {
    cidr_block     = var.cidr_rt_private
    nat_gateway_id = var.k8s_natgw
  }

  tags = {
    Name = var.rt_private_name
  }

}

resource "aws_route_table_association" "rt_private_association" {
  route_table_id = aws_route_table.rt_private.id
  subnet_id      = var.subnet_private
}