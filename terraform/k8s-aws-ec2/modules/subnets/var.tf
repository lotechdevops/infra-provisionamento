variable "vpc_k8s" {
  description = "ID da VPC onde as subnets serão criadas"
  type        = string
}

variable "config" {
  description = "Configuração das subnets"
  type = object({
    name_prefix          = string
    availability_zones   = list(string)
    private_subnet_cidrs = list(string)
    public_subnet_cidrs  = list(string)
  })
}
