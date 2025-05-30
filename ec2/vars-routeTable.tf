# ========================================
# ROUTE TABLE PÚBLICA
# ========================================

variable "cidr_rt_public" {
  description = "CIDR para rota pública (tráfego para internet)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "rt_public_name" {
  description = "Nome da route table pública"
  type        = string
  default     = "rt-public"
}

# ========================================
# ROUTE TABLE PRIVADA
# ========================================

variable "cidr_rt_private" {
  description = "CIDR para rota privada (tráfego para NAT Gateway)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "rt_private_name" {
  description = "Nome base das route tables privadas"
  type        = string
  default     = "rt-private"
}

# ========================================
# CONFIGURAÇÕES AVANÇADAS
# ========================================

variable "create_separate_route_tables" {
  description = "Criar route tables privadas separadas para cada AZ (alta disponibilidade)"
  type        = bool
  default     = false
}

# Exemplos de configuração:
# create_separate_route_tables = false  # 1 route table privada compartilhada (economia)
# create_separate_route_tables = true   # 1 route table por AZ (alta disponibilidade)