resource "aws_subnet" "subnet_private" {
  vpc_id            = var.vpc_k8s
  cidr_block        = var.subnet_private_cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = var.subnet_private_name
  }
}

resource "aws_subnet" "subnet_public" {
  vpc_id            = var.vpc_k8s
  cidr_block        = var.subnet_public_cidr_block
  availability_zone = var.availability_zone

  tags = {
    Name = var.subnet_public_name
  }
}