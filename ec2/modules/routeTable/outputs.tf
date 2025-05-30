# ========================================
# OUTPUTS PARA COMPATIBILIDADE
# ========================================

output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "ID da Route Table pública"
}

output "private_route_table_id" {
  value       = aws_route_table.private[0].id
  description = "ID da primeira Route Table privada (compatibilidade)"
}

# ========================================
# OUTPUTS MELHORADOS
# ========================================

output "public_route_table_ids" {
  value       = [aws_route_table.public.id]
  description = "Lista de IDs das Route Tables públicas"
}

output "private_route_table_ids" {
  value       = aws_route_table.private[*].id
  description = "Lista de IDs das Route Tables privadas"
}

output "public_associations" {
  value = {
    for i, assoc in aws_route_table_association.public :
    var.public_subnet_ids[i] => assoc.id
  }
  description = "Mapa de subnet ID para association ID (públicas)"
}

output "private_associations" {
  value = {
    for i, assoc in aws_route_table_association.private :
    var.private_subnet_ids[i] => assoc.id
  }
  description = "Mapa de subnet ID para association ID (privadas)"
}

output "route_table_summary" {
  value = {
    public = {
      route_table_id = aws_route_table.public.id
      route_count    = 1
      subnet_count   = length(var.public_subnet_ids)
      target         = "Internet Gateway"
    }
    private = {
      route_table_count = length(aws_route_table.private)
      route_table_ids   = aws_route_table.private[*].id
      subnet_count      = length(var.private_subnet_ids)
      target            = "NAT Gateway"
    }
  }
  description = "Resumo das configurações das route tables"
}