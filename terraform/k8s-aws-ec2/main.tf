module "vpc" {
  source   = "./modules/vpc"
  vpcCidr  = var.vpcCidr
  vpc_name = var.vpc_name
}

module "subnets" {
  source  = "./modules/subnets"
  vpc_k8s = module.vpc.vpc_k8s_id
  config  = local.subnet_config
}

module "internetGateway" {
  source   = "./modules/internetGateway"
  vpc_k8s  = module.vpc.vpc_k8s_id
  igw_name = var.igw_name
}

module "natGateway" {
  source            = "./modules/natGateway"
  k8s_nat_eip_name  = var.k8s_nat_eip_name
  public_subnet_ids = module.subnets.public_subnet_ids
  natgateway_name   = var.natgateway_name
}

module "routeTable" {
  source             = "./modules/routeTable"
  vpc_k8s            = module.vpc.vpc_k8s_id
  public_subnet_ids  = module.subnets.public_subnet_ids
  private_subnet_ids = module.subnets.private_subnet_ids
  igw_name           = module.internetGateway.k8s_igw_id
  k8s_natgw          = module.natGateway.k8s_natgw_id
  cidr_rt_public     = var.cidr_rt_public
  rt_public_name     = var.rt_public_name
  cidr_rt_private    = var.cidr_rt_private
  rt_private_name    = var.rt_private_name
}

module "securityGroup" {
  source              = "./modules/securityGroup"
  vpc_k8s             = module.vpc.vpc_k8s_id
  name_prefix_master  = var.name_prefix_master
  name_prefix_nodes   = var.name_prefix_nodes
  name_prefix_bastion = var.name_prefix_bastion
  allowed_ssh_cidr    = var.allowed_ssh_cidr
  master_rules        = var.master_rules
  node_rules          = var.node_rules
  bastion_rules       = var.bastion_rules
}


module "ec2" {
  source               = "./modules/ec2"
  public_subnet_ids    = module.subnets.public_subnet_ids
  private_subnet_ids   = module.subnets.private_subnet_ids
  instance_type_master = var.instance_type_master
  instance_type_worker = var.instance_type_worker
  worker_count         = var.worker_count
  host_key             = var.host_key
  sg_master_id         = module.securityGroup.sg_master_id
  sg_nodes_id          = module.securityGroup.sg_nodes_id
}

module "hostBastion" {
  source                = "./modules/hostBastion"
  public_subnet_ids     = module.subnets.public_subnet_ids
  instance_type_bastion = var.instance_type_bastion
  bastion_sg_id         = module.securityGroup.bastion_sg_id
  host_key              = var.host_key
}


# module "haproxy" {
#   source = "./modules/haproxy"
#   instance_type_haproxy = var.instance_type_haproxy
#   subnet_public = module.subnet.subnet_public
#   haproxy_sg_id = module.securityGroup.haproxy_sg_id
#   host_key = var.host_key
# }