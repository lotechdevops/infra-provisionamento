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
    alb = {
      name        = "alb-web-sg"
      description = "Security group para ALB"

      ingress_rules = {
        http = {
          description = "HTTP access"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        https = {  # ✅ MOVIDO PARA DENTRO do ingress_rules
          description = "HTTPS access"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }

      # ✅ ADICIONADO egress_rules para o ALB
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
        Purpose = "Application Load Balancer"
      }
    }

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
          source_security_group_id = "alb"  # ✅ CORRIGIDO - usar a chave, não resource
        }
        https = {
          description = "HTTPS access"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          source_security_group_id = "alb"  # ✅ CORRIGIDO - usar a chave, não resource
        }
        ssh = {
          description = "SSH access"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["192.168.0.0/16"]  # ✅ CORRIGIDO - apenas da VPC
        }
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