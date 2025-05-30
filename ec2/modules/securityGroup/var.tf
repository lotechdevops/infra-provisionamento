variable "vpc_demo_id" {
  description = "ID da VPC onde os security groups serão criados"
  type        = string
}

# ========================================
# CONFIGURAÇÃO DE SECURITY GROUPS
# ========================================

variable "security_groups" {
  description = "Mapa de security groups a serem criados"
  type = map(object({
    name        = string
    description = string

    # Regras de ingress (entrada)
    ingress_rules = optional(map(object({
      description              = string
      from_port                = number
      to_port                  = number
      protocol                 = string
      cidr_blocks              = optional(list(string))
      source_security_group_id = optional(string)
      self                     = optional(bool, false)
    })), {})

    # Regras de egress (saída)
    egress_rules = optional(map(object({
      description                   = string
      from_port                     = number
      to_port                       = number
      protocol                      = string
      cidr_blocks                   = optional(list(string))
      destination_security_group_id = optional(string)
      self                          = optional(bool, false)
    })), {})

    # Tags específicas para este security group
    tags = optional(map(string), {})
  }))

  default = {}
}

# ========================================
# CONFIGURAÇÕES GLOBAIS
# ========================================

variable "name_prefix" {
  description = "Prefixo para nomes dos security groups"
  type        = string
  default     = "demo"
}

variable "tags" {
  description = "Tags comuns para todos os security groups"
  type        = map(string)
  default     = {}
}

# ========================================
# VARIÁVEIS PARA COMPATIBILIDADE (DEPRECATED)
# ========================================

# variable "bastion_rules" {
#   description = "[DEPRECATED] Use security_groups ao invés desta variável"
#   type = map(object({
#     description = string
#     from_port   = number
#     to_port     = number
#     protocol    = string
#     cidr_blocks = optional(list(string))
#   }))
#   default = {}
# }

# variable "name_prefix_bastion" {
#   description = "[DEPRECATED] Use name_prefix ao invés desta variável"
#   type        = string
#   default     = ""
# }

# variable "allowed_ssh_cidr" {
#   description = "[DEPRECATED] Configure via security_groups"
#   type        = string
#   default     = ""
# }