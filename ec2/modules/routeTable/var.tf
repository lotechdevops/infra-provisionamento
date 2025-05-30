variable "vpc_demo_id" {
  description = "ID da VPC onde as route tables serão criadas"
  type        = string
}

# ========================================
# ROUTE TABLE PÚBLICA
# ========================================

variable "rt_public_name" {
  description = "Nome base para as route tables públicas"
  type        = string
}

variable "cidr_rt_public" {
  description = "CIDR block para rota pública (geralmente 0.0.0.0/0)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "public_subnet_ids" {
  description = "Lista de IDs das subnets públicas"
  type        = list(string)
}

variable "demo_igw_id" {
  description = "ID do Internet Gateway"
  type        = string
}

# ========================================
# ROUTE TABLE PRIVADA
# ========================================

variable "rt_private_name" {
  description = "Nome base para as route tables privadas"
  type        = string
}

variable "cidr_rt_private" {
  description = "CIDR block para rota privada (geralmente 0.0.0.0/0)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "private_subnet_ids" {
  description = "Lista de IDs das subnets privadas"
  type        = list(string)
}

variable "demo_nat_gateway_id" {
  description = "ID do NAT Gateway principal (compatibilidade)"
  type        = string
}

variable "nat_gateway_ids" {
  description = "Lista de IDs dos NAT Gateways (para alta disponibilidade)"
  type        = list(string)
  default     = []
}

# ========================================
# CONFIGURAÇÕES GERAIS
# ========================================

variable "create_separate_route_tables" {
  description = "Se deve criar route tables separadas para cada AZ (alta disponibilidade) ou usar compartilhadas"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags adicionais para aplicar às route tables"
  type        = map(string)
  default     = {}
}