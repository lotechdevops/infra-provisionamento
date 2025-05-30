# Determinar quantos NAT Gateways temos disponíveis
locals {
  # Usar NAT Gateway IDs se fornecidos, senão usar o ID único
  available_nat_gws = length(var.nat_gateway_ids) > 0 ? var.nat_gateway_ids : [var.demo_nat_gateway_id]

  # Determinar se devemos criar route tables separadas
  create_separate_rts = var.create_separate_route_tables && length(local.available_nat_gws) > 1

  # Número de route tables privadas a criar
  private_rt_count = local.create_separate_rts ? length(var.private_subnet_ids) : 1
}

# ========================================
# ROUTE TABLE PÚBLICA
# ========================================

# Route Table Pública (única, compartilhada por todas as subnets públicas)
resource "aws_route_table" "public" {
  vpc_id = var.vpc_demo_id

  # Rota para Internet Gateway
  route {
    cidr_block = var.cidr_rt_public
    gateway_id = var.demo_igw_id
  }

  tags = merge(
    var.tags,
    {
      Name = var.rt_public_name
      Type = "Public"
    }
  )
}

# Associações das subnets públicas com a route table pública
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_ids)

  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

# ========================================
# ROUTE TABLES PRIVADAS
# ========================================

# Route Tables Privadas
resource "aws_route_table" "private" {
  count = local.private_rt_count

  vpc_id = var.vpc_demo_id

  # Rota para NAT Gateway
  route {
    cidr_block     = var.cidr_rt_private
    nat_gateway_id = local.create_separate_rts ? local.available_nat_gws[count.index % length(local.available_nat_gws)] : local.available_nat_gws[0]
  }

  tags = merge(
    var.tags,
    {
      Name        = local.private_rt_count > 1 ? "${var.rt_private_name}-${count.index + 1}" : var.rt_private_name
      Type        = "Private"
      NAT_Gateway = local.create_separate_rts ? local.available_nat_gws[count.index % length(local.available_nat_gws)] : local.available_nat_gws[0]
    }
  )
}

# Associações das subnets privadas com as route tables privadas
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_ids)

  subnet_id = var.private_subnet_ids[count.index]

  # Se temos route tables separadas, cada subnet usa sua própria
  # Senão, todas usam a mesma route table
  route_table_id = local.create_separate_rts ? aws_route_table.private[count.index].id : aws_route_table.private[0].id
}