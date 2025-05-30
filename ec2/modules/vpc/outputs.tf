output "vpc_demo_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.vpc_demo.id
}

output "vpc_cidr" {
  description = "CIDR block da VPC"
  value       = aws_vpc.vpc_demo.cidr_block
}

output "vpc_arn" {
  description = "ARN da VPC"
  value       = aws_vpc.vpc_demo.arn
}

output "vpc_default_security_group_id" {
  description = "ID do security group padrão da VPC"
  value       = aws_vpc.vpc_demo.default_security_group_id
}

output "vpc_default_route_table_id" {
  description = "ID da route table padrão da VPC"
  value       = aws_vpc.vpc_demo.default_route_table_id
}