variable "name_prefix" {
  description = "Prefixo para nomeação dos recursos"
  type        = string
  default     = "demo"
}

variable "subnet_count" {
  description = "Número de subnets por tipo (pública/privada) a serem criadas"
  type        = number
  default     = 2
}

# ========================================
# NOVAS VARIÁVEIS PARA CIDRs ESPECÍFICOS
# ========================================

variable "public_subnet_cidrs" {
  description = "CIDRs específicos para subnets públicas"
  type        = list(string)
  default = [
    "192.168.1.0/24",
    "192.168.2.0/24"
  ]
}

variable "private_subnet_cidrs" {
  description = "CIDRs específicos para subnets privadas"
  type        = list(string)
  default = [
    "192.168.100.0/24",
    "192.168.200.0/24"
  ]
}

variable "subnet_newbits" {
  description = "Bits adicionais para subnet (usado apenas se CIDRs específicos não forem definidos)"
  type        = number
  default     = 8
}

variable "public_subnet_offset" {
  description = "Offset para numeração das subnets públicas (usado apenas se CIDRs específicos não forem definidos)"
  type        = number
  default     = 1
}

variable "private_subnet_offset" {
  description = "Offset para numeração das subnets privadas (usado apenas se CIDRs específicos não forem definidos)"
  type        = number
  default     = 10
}

variable "map_public_ip_on_launch" {
  description = "Mapear IP público nas subnets públicas"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "demo-project"
}

variable "common_tags" {
  description = "Tags comuns para todos os recursos"
  type        = map(string)
  default = {
    Terraform = "true"
    Owner     = "DevOps Team"
  }
}