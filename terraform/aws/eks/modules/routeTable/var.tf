variable "vpc_id" {
  type        = string
  description = "ID da VPC"
}

variable "igw_id" {
  type        = string
  description = "ID do Internet Gateway"
}

variable "nat_gateway_id" {
  type        = string
  description = "ID do NAT Gateway"
}

variable "public_subnet_ids" {
  type        = map(string)
  description = "Lista de subnets públicas a associar"
}

variable "private_subnet_ids" {
  type        = map(string)
  description = "Lista de subnets privadas a associar"
}

variable "name_prefix" {
  type        = string
  description = "Prefixo para nomear os recursos"
}
