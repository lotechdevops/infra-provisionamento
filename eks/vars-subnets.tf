locals {
  subnet_config = {
    name_prefix          = "eks-dev"
    availability_zones   = ["us-east-1a", "us-east-1b"]
    private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
    public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24"]
  }
}
