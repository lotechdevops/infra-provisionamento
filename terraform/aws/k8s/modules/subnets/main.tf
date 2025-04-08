resource "aws_subnet" "private" {
  for_each = {
    for index, az in var.config.availability_zones :
    "${az}-private" => {
      az         = az
      cidr_block = var.config.private_subnet_cidrs[index]
      name       = "${var.config.name_prefix}-private-${az}"
    }
  }

  vpc_id                  = var.vpc_k8s
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = {
    Name = each.value.name
  }
}

resource "aws_subnet" "public" {
  for_each = {
    for index, az in var.config.availability_zones :
    "${az}-public" => {
      az         = az
      cidr_block = var.config.public_subnet_cidrs[index]
      name       = "${var.config.name_prefix}-public-${az}"
    }
  }

  vpc_id                  = var.vpc_k8s
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = each.value.name
  }
}
