locals {
  eks_node_groups = {
    "ng-apps" = {
      instance_types    = ["t3.medium"]
      desired_size      = 1
      min_size          = 1
      max_size          = 3
      subnets           = values(module.subnets.private_subnets)
      capacity_type     = "SPOT"
      node_role_arn     = module.iamEks.eks_node_role_arn
      security_group_id = module.eks_nodes_sg.security_group_id
    }

    "ng-monitoring" = {
      instance_types    = ["t3.medium"]
      desired_size      = 1
      min_size          = 1
      max_size          = 3
      subnets           = values(module.subnets.private_subnets)
      capacity_type     = "SPOT"
      node_role_arn     = module.iamEks.eks_node_role_arn
      security_group_id = module.eks_nodes_sg.security_group_id
    }
  }
}
