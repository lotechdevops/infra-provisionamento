module "vpc" {
  source   = "./modules/vpc"
  vpcCidr  = var.vpcCidr
  vpc_name = var.vpc_name
}

module "subnet" {
  source                    = "./modules/subnet"
  vpc_k8s                   = module.vpc.vpc_k8s_id
  subnet_private_cidr_block = var.subnet_private_cidr_block
  subnet_private_name       = var.subnet_private_name
  subnet_public_cidr_block  = var.subnet_public_cidr_block
  subnet_public_name        = var.subnet_public_name
  availability_zone         = var.availability_zone
}

module "routeTable" {
  source          = "./modules/routeTable"
  vpc_k8s         = module.vpc.vpc_k8s_id
  subnet_public   = module.subnet.subnet_public
  subnet_private  = module.subnet.subnet_private
  igw_name        = module.internetGateway.k8s_igw_id
  k8s_natgw       = module.natgateway.k8s_natgw_id
  cidr_rt_public  = var.cidr_rt_public
  rt_public_name  = var.rt_public_name
  cidr_rt_private = var.cidr_rt_private
  rt_private_name = var.rt_private_name
}

module "internetGateway" {
  source   = "./modules/internetGateway"
  vpc_k8s  = module.vpc.vpc_k8s_id
  igw_name = var.igw_name
}

module "natgateway" {
  source          = "./modules/natgateway"
  k8s_nat_eip_name = var.k8s_nat_eip_name
  subnet_public   = module.subnet.subnet_public
  natgateway_name = var.natgateway_name

}

module "ec2" {
  source = "./modules/ec2"
  instance_type_master = var.instance_type_master
  subnet_private = module.subnet.subnet_private
  instance_type_worker = var.instance_type_worker
  worker_count = var.worker_count
  host_key = var.host_key
  k8s_sg_id = module.securityGroup.k8s_sg_id
}

module "securityGroup" {
  source = "./modules/securityGroup"
  vpc_k8s = module.vpc.vpc_k8s_id
}

module "hostBastion" {
  source = "./modules/hostBastion"
  instance_type_bastion = var.instance_type_bastion
  subnet_public = module.subnet.subnet_public
  bastion_sg_id = module.securityGroup.bastion_sg_id
  host_key = var.host_key
}

module "haproxy" {
  source = "./modules/haproxy"
  instance_type_haproxy = var.instance_type_haproxy
  subnet_public = module.subnet.subnet_public
  haproxy_sg_id = module.securityGroup.haproxy_sg_id
  host_key = var.host_key
}