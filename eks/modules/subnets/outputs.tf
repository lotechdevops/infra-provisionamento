output "public_subnets" {
  value = {
    for subnet in aws_subnet.public :
    subnet.availability_zone => subnet.id
  }
}

output "private_subnets" {
  value = {
    for subnet in aws_subnet.private :
    subnet.availability_zone => subnet.id
  }
}
