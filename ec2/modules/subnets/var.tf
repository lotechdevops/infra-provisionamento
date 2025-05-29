variable "vpc_demo_id" {
  description = "ID da VPC onde as subnets serão criadas"
  type        = string
}

variable "subnet_public_cidr" {
  description = "CIDR das subnets"
  type        = string
}

variable "availability_zone" {
  description = "Zona de disponibilidade"
  type        = string
}

variable "name_prefix" {
  description = "Prefixo do nome da subnet"
  type        = string

}

variable "subnet_private_cidr" {
  description = "CIDR das subnets"
  type        = string
}

