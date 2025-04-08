resource "aws_route_table" "public" {
  vpc_id = var.vpc_k8s

  route {
    cidr_block = var.cidr_rt_public
    gateway_id = var.igw_name
  }

  tags = {
    Name = var.rt_public_name
  }
}

resource "aws_route_table_association" "public" {
  for_each = {
  for idx, subnet_id in var.public_subnet_ids :
  "public-${idx}" => subnet_id
}
  route_table_id = aws_route_table.public.id
  subnet_id      = each.value
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_k8s

  route {
    cidr_block     = var.cidr_rt_private
    nat_gateway_id = var.k8s_natgw
  }

  tags = {
    Name = var.rt_private_name
  }
}

resource "aws_route_table_association" "private" {
  for_each = {
  for idx, subnet_id in var.private_subnet_ids :
  "private-${idx}" => subnet_id
}

  subnet_id = each.value

  route_table_id = aws_route_table.private.id
}
