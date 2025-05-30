variable "vpc_demo_id" {
  description = "ID da VPC onde as subnets serão criadas"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block da VPC (usado apenas para geração automática se CIDRs específicos não forem fornecidos)"
  type        = string
}

variable "subnet_count" {
  description = "Número de subnets (e zonas de disponibilidade) a serem criadas"
  type        = number
  default     = 2

  validation {
    condition     = var.subnet_count >= 1 && var.subnet_count <= 6
    error_message = "O número de subnets deve estar entre 1 e 6."
  }
}

# ========================================
# NOVAS VARIÁVEIS PARA CIDRs ESPECÍFICOS
# ========================================

variable "public_subnet_cidrs" {
  description = "Lista de CIDRs específicos para as subnets públicas (ex: ['10.0.1.0/24', '10.0.2.0/24']). Se vazia, será gerada automaticamente."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for cidr in var.public_subnet_cidrs :
      can(cidrhost(cidr, 0))
    ])
    error_message = "Todos os CIDRs públicos devem estar em formato válido (ex: '10.0.1.0/24')."
  }
}

variable "private_subnet_cidrs" {
  description = "Lista de CIDRs específicos para as subnets privadas (ex: ['10.0.10.0/24', '10.0.11.0/24']). Se vazia, será gerada automaticamente."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for cidr in var.private_subnet_cidrs :
      can(cidrhost(cidr, 0))
    ])
    error_message = "Todos os CIDRs privados devem estar em formato válido (ex: '10.0.10.0/24')."
  }
}

# ========================================
# VARIÁVEIS PARA GERAÇÃO AUTOMÁTICA (mantidas para compatibilidade)
# ========================================

variable "subnet_newbits" {
  description = "Número de bits adicionais para as subnets (usado apenas se CIDRs específicos não forem fornecidos)"
  type        = number
  default     = 8
}

variable "public_subnet_offset" {
  description = "Offset inicial para numeração das subnets públicas (usado apenas se CIDRs específicos não forem fornecidos)"
  type        = number
  default     = 1
}

variable "private_subnet_offset" {
  description = "Offset inicial para numeração das subnets privadas (usado apenas se CIDRs específicos não forem fornecidos)"
  type        = number
  default     = 10
}

# ========================================
# OUTRAS VARIÁVEIS
# ========================================

variable "name_prefix" {
  description = "Prefixo do nome das subnets"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Se deve mapear IP público automaticamente nas subnets públicas"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags adicionais para aplicar às subnets"
  type        = map(string)
  default     = {}
}

# Variáveis opcionais para compatibilidade com o código antigo
variable "availability_zones" {
  description = "Lista específica de zonas de disponibilidade (opcional - se não especificada, usa as AZs disponíveis automaticamente)"
  type        = list(string)
  default     = []
}