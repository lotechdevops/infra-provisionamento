# Módulo refatorado com blocos de regra compactos por grupo (master, nodes, bastion)

variable "vpc_k8s" {
  type = string
}

variable "name_prefix_master" {
  type = string
}

variable "name_prefix_nodes" {
  type = string
}

variable "name_prefix_bastion" {
  type = string
}

variable "allowed_ssh_cidr" {
  type = string
}

variable "master_rules" {
  type = map(object({
    description  = string
    from_port    = number
    to_port      = number
    protocol     = string
    cidr_blocks  = optional(list(string))
  }))
}

variable "node_rules" {
  type = map(object({
    description  = string
    from_port    = number
    to_port      = number
    protocol     = string
    cidr_blocks  = optional(list(string))
  }))
}

variable "bastion_rules" {
  type = map(object({
    description  = string
    from_port    = number
    to_port      = number
    protocol     = string
    cidr_blocks  = optional(list(string))
  }))
}

# O conteúdo do main.tf permanece o mesmo a partir deste ponto
