resource "aws_subnet" "subnet_public_demo" {
  vpc_id                  = var.vpc_demo_id
  cidr_block              = var.subnet_public_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name_prefix}-public-${var.availability_zone}"
  }
}

resource "aws_subnet" "subnet_private_demo" {
  vpc_id                  = var.vpc_demo_id
  cidr_block              = var.subnet_private_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.name_prefix}-private-${var.availability_zone}"
  }
}