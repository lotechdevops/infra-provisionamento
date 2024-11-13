variable "vpc_k8s" {}

variable "subnet_private_cidr_block" {
  type = string
}

variable "subnet_private_name" {
  type = string
}

variable "subnet_public_cidr_block" {
  type = string
}

variable "subnet_public_name" {
  type = string
}

variable "availability_zone" {
  type = string
}