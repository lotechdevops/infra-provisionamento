output "private_subnet_ids" {
  description = "IDs das subnets privadas"
  value       = aws_subnet.subnet_private_demo[*].id
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = aws_subnet.subnet_public_demo[*].id
}

output "private_subnet_cidrs" {
  description = "CIDRs das subnets privadas"
  value       = aws_subnet.subnet_private_demo[*].cidr_block
}

output "public_subnet_cidrs" {
  description = "CIDRs das subnets públicas"
  value       = aws_subnet.subnet_public_demo[*].cidr_block
}

output "availability_zones" {
  description = "Zonas de disponibilidade utilizadas"
  value       = aws_subnet.subnet_public_demo[*].availability_zone
}

output "private_subnet_map" {
  description = "Mapa de AZ para ID da subnet privada"
  value = {
    for subnet in aws_subnet.subnet_private_demo :
    subnet.availability_zone => subnet.id
  }
}

output "public_subnet_map" {
  description = "Mapa de AZ para ID da subnet pública"
  value = {
    for subnet in aws_subnet.subnet_public_demo :
    subnet.availability_zone => subnet.id
  }
}