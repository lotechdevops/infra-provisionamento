# vars-securityGroup.tf (root)

variable "name_prefix_master" {
  default = "k8s-master"
}

variable "name_prefix_nodes" {
  default = "k8s-nodes"
}

variable "name_prefix_bastion" {
  default = "bastion"
}

variable "allowed_ssh_cidr" {
  default = "0.0.0.0/0"
}

variable "master_rules" {
  default = {
    api = {
      description = "Kubernetes API"
      from_port   = 6443
      to_port     = 6443
      protocol    = "tcp"
    }
    ssh = {
      description = "SSH do Bastion"
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

variable "node_rules" {
  default = {
    api = {
      description = "API Server from Master"
      from_port   = 6443
      to_port     = 6443
      protocol    = "tcp"
    }
    kubelet = {
      description = "Kubelet"
      from_port   = 10250
      to_port     = 10250
      protocol    = "tcp"
    }
    dns_tcp = {
      description = "DNS TCP"
      from_port   = 53
      to_port     = 53
      protocol    = "tcp"
    }
    dns_udp = {
      description = "DNS UDP"
      from_port   = 53
      to_port     = 53
      protocol    = "udp"
    }
    ssh = {
      description = "SSH do Bastion"
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
