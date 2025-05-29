output "private_subnet_ids" {
  value = aws_subnet.subnet_private_demo.id
}


output "public_subnet_ids" {
  value = aws_subnet.subnet_public_demo.id
}
