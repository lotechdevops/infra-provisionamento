output "igw_id" {
  description = "ID do Internet Gateway"
  value       = aws_internet_gateway.demo_igw.id
}

output "igw_arn" {
  description = "ARN do Internet Gateway"
  value       = aws_internet_gateway.demo_igw.arn
}

output "igw_owner_id" {
  description = "ID do proprietário do Internet Gateway"
  value       = aws_internet_gateway.demo_igw.owner_id
}

output "attachment_id" {
  description = "ID do attachment do Internet Gateway à VPC"
  value       = aws_internet_gateway_attachment.demo_igw_attachment.id
}