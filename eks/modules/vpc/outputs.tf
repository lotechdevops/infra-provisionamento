output "vpc_id" {
  description = "ID da VPC criada"
  value       = aws_vpc.this.id
}
