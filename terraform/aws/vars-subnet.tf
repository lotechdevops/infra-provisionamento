variable "vpc_k8s" {
  default = ""
}

variable "subnet_private_cidr_block" {
  default = "192.168.2.0/24"
}

variable "subnet_private_name" {
  default = "subnet_private"
}

variable "subnet_public_cidr_block" {
  default = "192.168.1.0/24"
}

variable "subnet_public_name" {
  default = "subnet_public"
}

variable "availability_zone" {
  default = "us-east-1a"
}