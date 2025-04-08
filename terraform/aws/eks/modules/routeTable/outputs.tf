output "public_route_table_id" {
  value       = aws_route_table.public.id
  description = "ID da Route Table pública"
}

output "private_route_table_id" {
  value       = aws_route_table.private.id
  description = "ID da Route Table privada"
}
