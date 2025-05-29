variable "vpc_demo_id" {
  type = string
}

variable "rt_public_name" {
  type = string
}

variable "cidr_rt_public" {
  type = string
}

variable "rt_private_name" {
  type = string
}

variable "cidr_rt_private" {
  type = string
}


variable "public_subnet_ids" {
  type = string
}

variable "private_subnet_ids" {
  type = string
}

variable "demo_igw_id" {
  type = string
}

variable "demo_nat_gateway_id" {
  type = string
}