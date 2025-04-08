locals {
  security_group_config = {
    name_prefix_master = "k8s-dev-master"
    name_prefix_nodes  = "k8s-dev-nodes"
  }

  sg_ingress_master = {
    kube_api = {
      from_port   = 6443
      to_port     = 6443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    kubelet = {
      from_port  = 10250
      to_port    = 10250
      protocol   = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  sg_ingress_nodes = {
    api_server_https = {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      source_security_group_id = null # será preenchido via override no main.tf depois de criar o sg_master
    },
    kubelet = {
      from_port                = 10250
      to_port                  = 10250
      protocol                 = "tcp"
      source_security_group_id = null
    },
    dns_tcp = {
      from_port                = 53
      to_port                  = 53
      protocol                 = "tcp"
      source_security_group_id = null
    },
    dns_udp = {
      from_port                = 53
      to_port                  = 53
      protocol                 = "udp"
      source_security_group_id = null
    }
  }

  sg_egress_default = {
    all = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
