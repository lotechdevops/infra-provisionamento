# Data source para obter as zonas de disponibilidade
data "aws_availability_zones" "available" {
  state = "available"
}

# Validações e cálculos locais
locals {
  # Pegar apenas o número de AZs necessário
  selected_azs = slice(data.aws_availability_zones.available.names, 0, var.subnet_count)

  # Usar CIDRs específicos fornecidos ou gerar automaticamente se não fornecidos
  public_cidrs = length(var.public_subnet_cidrs) > 0 ? var.public_subnet_cidrs : [
    for i in range(var.subnet_count) :
    cidrsubnet(var.vpc_cidr, var.subnet_newbits, var.public_subnet_offset + i)
  ]

  private_cidrs = length(var.private_subnet_cidrs) > 0 ? var.private_subnet_cidrs : [
    for i in range(var.subnet_count) :
    cidrsubnet(var.vpc_cidr, var.subnet_newbits, var.private_subnet_offset + i)
  ]
}

# Validação para garantir que o número de CIDRs corresponde ao número de subnets
resource "null_resource" "validate_cidrs" {
  count = var.subnet_count

  # Validação para subnets públicas
  lifecycle {
    precondition {
      condition     = length(var.public_subnet_cidrs) == 0 || length(var.public_subnet_cidrs) == var.subnet_count
      error_message = "O número de CIDRs públicos deve ser igual ao número de subnets (${var.subnet_count}) ou zero para usar geração automática."
    }

    precondition {
      condition     = length(var.private_subnet_cidrs) == 0 || length(var.private_subnet_cidrs) == var.subnet_count
      error_message = "O número de CIDRs privados deve ser igual ao número de subnets (${var.subnet_count}) ou zero para usar geração automática."
    }
  }
}

# Criar subnets públicas
resource "aws_subnet" "subnet_public_demo" {
  count = var.subnet_count

  vpc_id                  = var.vpc_demo_id
  cidr_block              = local.public_cidrs[count.index]
  availability_zone       = local.selected_azs[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-public-${substr(local.selected_azs[count.index], -1, 1)}"
      Type = "Public"
      AZ   = local.selected_azs[count.index]
      CIDR = local.public_cidrs[count.index]
    }
  )

  depends_on = [null_resource.validate_cidrs]
}

# Criar subnets privadas
resource "aws_subnet" "subnet_private_demo" {
  count = var.subnet_count

  vpc_id                  = var.vpc_demo_id
  cidr_block              = local.private_cidrs[count.index]
  availability_zone       = local.selected_azs[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-private-${substr(local.selected_azs[count.index], -1, 1)}"
      Type = "Private"
      AZ   = local.selected_azs[count.index]
      CIDR = local.private_cidrs[count.index]
    }
  )

  depends_on = [null_resource.validate_cidrs]
}