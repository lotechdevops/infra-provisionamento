module "vpc" {
  source   = "./modules/vpc"
  vpcCidr  = var.vpcCidr
  vpc_name = var.vpc_name
}

module "subnets" {
  source                  = "./modules/subnets"
  vpc_demo_id             = module.vpc.vpc_demo_id
  vpc_cidr                = module.vpc.vpc_cidr
  name_prefix             = var.name_prefix
  subnet_count            = var.subnet_count
  private_subnet_cidrs    = var.private_subnet_cidrs
  public_subnet_cidrs     = var.public_subnet_cidrs
  subnet_newbits          = var.subnet_newbits
  public_subnet_offset    = var.public_subnet_offset
  private_subnet_offset   = var.private_subnet_offset
  map_public_ip_on_launch = var.map_public_ip_on_launch
  tags = merge(var.common_tags, {
    Environment = var.environment
    Project     = var.project_name
  })
}

module "internetGateway" {
  source      = "./modules/internetGateway"
  vpc_demo_id = module.vpc.vpc_demo_id
  igw_name    = var.igw_name

  tags = merge(var.common_tags, {
    Environment = var.environment
    Project     = var.project_name
  })
}

module "natGateway" {
  source             = "./modules/natGateway"
  demo_nat_eip_name  = var.demo_nat_eip_name
  natgateway_name    = var.natgateway_name
  nat_gateway_count  = var.nat_gateway_count
  subnet_public_demo = module.subnets.public_subnet_ids
  tags = merge(var.common_tags, {
    Environment = var.environment
    Project     = var.project_name
  })
}

module "routeTable" {
  source      = "./modules/routeTable"
  vpc_demo_id = module.vpc.vpc_demo_id

  # Route Table Pública
  rt_public_name    = var.rt_public_name
  cidr_rt_public    = var.cidr_rt_public
  public_subnet_ids = module.subnets.public_subnet_ids
  demo_igw_id       = module.internetGateway.igw_id

  # Route Table Privada
  rt_private_name    = var.rt_private_name
  cidr_rt_private    = var.cidr_rt_private
  private_subnet_ids = module.subnets.private_subnet_ids

  # NAT Gateway (compatibilidade + flexibilidade)
  demo_nat_gateway_id = module.natGateway.demo_natgw_id
  nat_gateway_ids     = module.natGateway.nat_gateway_ids

  # Configurações avançadas
  create_separate_route_tables = var.create_separate_route_tables

  # Tags consistentes
  tags = merge(var.common_tags, {
    Environment = var.environment
    Project     = var.project_name
  })
}

module "securityGroup" {
  source      = "./modules/securityGroup"
  vpc_demo_id = module.vpc.vpc_demo_id
  name_prefix = var.name_prefix

  # Security groups flexíveis
  security_groups = var.security_groups

  # Tags consistentes
  tags = merge(var.common_tags, {
    Environment = var.environment
    Project     = var.project_name
  })
}