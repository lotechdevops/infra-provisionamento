module "vpc" {
  source   = "./modules/vpc"
  vpcCidr  = var.vpcCidr
  vpc_name = var.vpc_name
}

module "subnets" {
  source              = "./modules/subnets"
  vpc_demo_id         = module.vpc.vpc_demo_id
  subnet_public_cidr  = var.subnet_public_cidr
  subnet_private_cidr = var.subnet_private_cidr
  availability_zone   = var.availability_zone
  name_prefix         = var.name_prefix
}

module "internetGateway" {
  source      = "./modules/internetGateway"
  vpc_demo_id = module.vpc.vpc_demo_id
  igw_name    = var.igw_name
}

module "natGateway" {
  source             = "./modules/natGateway"
  demo_nat_eip_name  = var.demo_nat_eip_name
  natgateway_name    = var.natgateway_name
  subnet_public_demo = module.subnets.public_subnet_ids
}

module "routeTable" {
  source              = "./modules/routeTable"
  vpc_demo_id         = module.vpc.vpc_demo_id
  public_subnet_ids   = module.subnets.public_subnet_ids
  rt_public_name      = var.rt_public_name
  cidr_rt_public      = var.cidr_rt_public
  demo_igw_id         = module.internetGateway.igw_id
  demo_nat_gateway_id = module.natGateway.demo_natgw_id
  private_subnet_ids  = module.subnets.private_subnet_ids
  rt_private_name     = var.rt_private_name
  cidr_rt_private     = var.cidr_rt_private
}

module "securityGroup" {
  source              = "./modules/securityGroup"
  vpc_demo_id         = module.vpc.vpc_demo_id
  name_prefix_bastion = var.name_prefix_bastion
  allowed_ssh_cidr    = var.allowed_ssh_cidr
  bastion_rules       = var.bastion_rules
}

module "ec2Bastion" {
  source                       = "./modules/ec2Bastion"
  private_subnet_ids           = module.subnets.private_subnet_ids
  instance_type_bastion        = var.instance_type_bastion
  bastion_sg_id                = module.securityGroup.bastion_sg_id
  tag_name_instance            = var.tag_name_instance
  market_type_instance_bastion = var.market_type_instance_bastion
  key_name                     = var.key_name
}