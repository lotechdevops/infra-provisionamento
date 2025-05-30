variable "demo_nat_eip_name" {
  description = "Nome do Elastic IP para o NAT Gateway"
  type        = string
}

variable "natgateway_name" {
  description = "Nome do NAT Gateway"
  type        = string
}

variable "subnet_public_demo" {
  description = "Lista de IDs das subnets públicas onde o NAT Gateway será criado"
  type        = list(string)
}

variable "nat_gateway_count" {
  description = "Número de NAT Gateways a serem criados (geralmente 1 por AZ para alta disponibilidade)"
  type        = number
  default     = 1

  validation {
    condition     = var.nat_gateway_count >= 1 && var.nat_gateway_count <= 6
    error_message = "O número de NAT Gateways deve estar entre 1 e 6."
  }
}

variable "tags" {
  description = "Tags adicionais para aplicar aos recursos do NAT Gateway"
  type        = map(string)
  default     = {}
}