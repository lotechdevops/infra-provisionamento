# ========================================
# CONFIGURAÇÃO FLEXÍVEL DE SECURITY GROUPS
# ========================================

variable "security_groups" {
  description = "Configuração dos security groups"
  type = map(object({
    name        = string
    description = string

    ingress_rules = optional(map(object({
      description              = string
      from_port                = number
      to_port                  = number
      protocol                 = string
      cidr_blocks              = optional(list(string))
      source_security_group_id = optional(string)
      self                     = optional(bool, false)
    })), {})

    egress_rules = optional(map(object({
      description                   = string
      from_port                     = number
      to_port                       = number
      protocol                      = string
      cidr_blocks                   = optional(list(string))
      destination_security_group_id = optional(string)
      self                          = optional(bool, false)
    })), {})

    tags = optional(map(string), {})
  }))

  default = {
    # Security Group para Web Servers
    web = {
      name        = "web-sg"
      description = "Security group para servidores web"

      ingress_rules = {
        http = {
          description = "HTTP access"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        https = {
          description = "HTTPS access"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        ssh = {
          description              = "SSH access"
          from_port                = 22
          to_port                  = 22
          protocol                 = "tcp"
          cidr_blocks              = ["0.0.0.0/0"]
        }
        # ssh_from_bastion = {
        #   description              = "SSH from bastion"
        #   from_port               = 22
        #   to_port                 = 22
        #   protocol                = "tcp"
        #   source_security_group_id = "bastion"  # Referência ao SG do bastion
        # }
      }

      egress_rules = {
        all_outbound = {
          description = "All outbound traffic"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }

      tags = {
        Purpose = "Web Servers"
      }
    }
  }
}