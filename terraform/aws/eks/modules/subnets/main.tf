resource "aws_subnet" "private" {
  for_each = {
    for idx, az in var.availability_zones : az => {
      cidr = var.private_subnet_cidrs[idx]
    }
  }

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.key

  tags = {
    Name = "${var.name_prefix}-subnet-private-${each.key}"
  }
}

resource "aws_subnet" "public" {
  for_each = {
    for idx, az in var.availability_zones : az => {
      cidr = var.public_subnet_cidrs[idx]
    }
  }

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-subnet-public-${each.key}"
  }
}
