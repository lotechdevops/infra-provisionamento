variable "name_prefix" {
  type        = string
  description = "Prefixo usado para nomear os recursos"
}

variable "public_subnet_id" {
  type        = string
  description = "ID da subnet pública onde o NAT Gateway será criado"
}
