variable "vpc_k8s" {
  type = string
}

variable "name_prefix_master" {
  type = string
}

variable "name_prefix_nodes" {
  type = string
}

variable "sg_ingress_master" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}

variable "sg_ingress_nodes" {
  type = map(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    source_security_group_id = optional(string)
    cidr_blocks              = optional(list(string))
  }))
}

variable "sg_egress" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}
