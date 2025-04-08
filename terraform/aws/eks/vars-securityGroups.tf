locals {
  security_group_config = {
    name_prefix_api   = "eks-api"
    name_prefix_nodes = "eks-nodes"
  }

  sg_ingress_api = {
    all_tcp = {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  sg_ingress_nodes = {
    api_server_https = {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      source_security_group_id = module.eks_api_sg.security_group_id
    }

    kubelet = {
      from_port                = 10250
      to_port                  = 10250
      protocol                 = "tcp"
      source_security_group_id = module.eks_api_sg.security_group_id
    }

    dns_tcp = {
      from_port                = 53
      to_port                  = 53
      protocol                 = "tcp"
      source_security_group_id = module.eks_api_sg.security_group_id
    }

    dns_udp = {
      from_port                = 53
      to_port                  = 53
      protocol                 = "udp"
      source_security_group_id = module.eks_api_sg.security_group_id
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
