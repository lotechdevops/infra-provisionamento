variable "natgateway_name" {
  description = "Nome base para os NAT Gateways"
  type        = string
  default     = "demo-natgw"
}

variable "demo_nat_eip_name" {
  description = "Nome base para os Elastic IPs dos NAT Gateways"
  type        = string
  default     = "demo-nat-eip"
}

variable "nat_gateway_count" {
  description = "Número de NAT Gateways a criar (recomendado: 1 por AZ para alta disponibilidade)"
  type        = number
  default     = 1
}

# Exemplos de configuração:
# nat_gateway_count = 1  # Apenas 1 NAT Gateway (economia de custos)
# nat_gateway_count = 2  # 1 NAT Gateway por AZ (alta disponibilidade)