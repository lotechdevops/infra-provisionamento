variable "vpc_id" {
  type        = string
  description = "ID da VPC"
}

variable "name_prefix" {
  type        = string
  description = "Prefixo para nomear os recursos"
}

variable "availability_zones" {
  type        = list(string)
  description = "Zonas de disponibilidade"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Lista de CIDRs para subnets privadas"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Lista de CIDRs para subnets públicas"
}
