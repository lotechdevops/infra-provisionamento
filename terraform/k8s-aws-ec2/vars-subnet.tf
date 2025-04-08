locals {
  subnet_config = {
    name_prefix          = "k8s-dev"
    availability_zones   = ["us-east-1a", "us-east-1b"]
    private_subnet_cidrs = ["192.168.1.0/24", "192.168.2.0/24"]
    public_subnet_cidrs  = ["192.168.101.0/24", "192.168.102.0/24"]
  }
}
