output "nat_gateway_id" {
  description = "ID do NAT Gateway"
  value       = aws_nat_gateway.this.id
}

output "eip_id" {
  description = "ID do Elastic IP"
  value       = aws_eip.this.id
}
