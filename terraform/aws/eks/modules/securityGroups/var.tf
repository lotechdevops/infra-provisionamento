variable "vpc_id" {
  type        = string
  description = "ID da VPC"
}

variable "name_prefix" {
  type        = string
  description = "Prefixo para nomear o SG"
}

variable "ingress_rules" {
  type = map(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string))
    source_security_group_id = optional(string)
  }))
  default = {}
}

variable "egress_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = {}
}