output "demo_natgw_id" {
  description = "ID do primeiro NAT Gateway (compatibilidade)"
  value       = aws_nat_gateway.demo_natgw[0].id
}

output "nat_gateway_ids" {
  description = "Lista de IDs de todos os NAT Gateways"
  value       = aws_nat_gateway.demo_natgw[*].id
}

output "nat_gateway_public_ips" {
  description = "Lista de IPs públicos dos NAT Gateways"
  value       = aws_eip.nat_eip[*].public_ip
}

output "elastic_ip_ids" {
  description = "Lista de IDs dos Elastic IPs"
  value       = aws_eip.nat_eip[*].id
}

output "nat_gateway_map" {
  description = "Mapa de subnet ID para NAT Gateway ID"
  value = {
    for i, nat_gw in aws_nat_gateway.demo_natgw :
    var.subnet_public_demo[i] => nat_gw.id
  }
}