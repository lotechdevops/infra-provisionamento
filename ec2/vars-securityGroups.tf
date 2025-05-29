variable "name_prefix_bastion" {
  default = "bastion"
}

variable "allowed_ssh_cidr" {
  default = "0.0.0.0/0"
}

variable "bastion_rules" {
  default = {
    ssh = {
      description = "Acesso SSH ao bastion"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
    }
    egress = {
      description = "Allow all outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}