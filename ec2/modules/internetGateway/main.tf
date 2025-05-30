resource "aws_internet_gateway" "demo_igw" {
  tags = merge(
    var.tags,
    {
      Name = var.igw_name
    }
  )
}

# Anexar o Internet Gateway à VPC
resource "aws_internet_gateway_attachment" "demo_igw_attachment" {
  internet_gateway_id = aws_internet_gateway.demo_igw.id
  vpc_id              = var.vpc_demo_id
}