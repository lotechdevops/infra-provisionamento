module "vpc" {
  source      = "./modules/vpc"
  vpc_cidr    = local.vpc_config.vpc_cidr
  name_prefix = local.vpc_config.name_prefix
}

module "subnets" {
  source               = "./modules/subnets"
  vpc_id               = module.vpc.vpc_id
  name_prefix          = local.subnet_config.name_prefix
  availability_zones   = local.subnet_config.availability_zones
  private_subnet_cidrs = local.subnet_config.private_subnet_cidrs
  public_subnet_cidrs  = local.subnet_config.public_subnet_cidrs
}


module "routeTable" {
  source             = "./modules/routeTable"
  name_prefix        = local.route_table_config.name_prefix
  vpc_id             = module.vpc.vpc_id
  igw_id             = module.internetGateway.igw_id
  nat_gateway_id     = module.natGateway.nat_gateway_id
  public_subnet_ids  = module.subnets.public_subnets
  private_subnet_ids = module.subnets.private_subnets
}


module "internetGateway" {
  source      = "./modules/internetGateway"
  vpc_id      = module.vpc.vpc_id
  name_prefix = local.igw_config.name_prefix
}


module "natGateway" {
  source           = "./modules/natGateway"
  name_prefix      = local.nat_gateway_config.name_prefix
  public_subnet_id = module.subnets.public_subnets[local.nat_gateway_config.public_subnet_az]
}

module "eks_api_sg" {
  source        = "./modules/securityGroups"
  name_prefix   = local.security_group_config.name_prefix_api
  vpc_id        = module.vpc.vpc_id
  ingress_rules = local.sg_ingress_api
  egress_rules  = local.sg_egress_default
}

module "eks_nodes_sg" {
  source        = "./modules/securityGroups"
  name_prefix   = local.security_group_config.name_prefix_nodes
  vpc_id        = module.vpc.vpc_id
  ingress_rules = local.sg_ingress_nodes
  egress_rules  = local.sg_egress_default
}

module "iamEks" {
  source = "./modules/iamEks"
}

module "eks" {
  source                    = "./modules/eks"
  name_prefix               = local.eks_config.name_prefix
  kubernetes_version        = local.eks_config.kubernetes_version
  cluster_role_arn          = module.iamEks.eks_cluster_role_arn
  cluster_security_group_id = module.eks_api_sg.security_group_id
  public_subnet_ids         = values(module.subnets.public_subnets)
}


module "eksNodeGroups" {
  source       = "./modules/eksNodeGroups"
  name_prefix  = "eks-dev"
  cluster_name = module.eks.cluster_name
  node_groups  = local.eks_node_groups
}

module "eks-addons" {
  source       = "./modules/eks-addons"
  cluster_name = module.eks.cluster_name
  name_prefix  = local.eks_config.name_prefix
  addons       = local.eks_addons_config
}


