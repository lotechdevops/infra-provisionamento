variable "bastion_rules" {
  type = map(object({
    description  = string
    from_port    = number
    to_port      = number
    protocol     = string
    cidr_blocks  = optional(list(string))
  }))
}

variable "name_prefix_bastion" {
  type = string
}

variable "allowed_ssh_cidr" {
  type = string
}

variable "vpc_demo_id" {
  type = string
}
