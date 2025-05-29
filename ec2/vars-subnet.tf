variable "subnet_public_cidr" {
  default = "192.168.1.0/24"
}

variable "subnet_private_cidr" {
  default = "192.168.2.0/24"
}

variable "availability_zone" {
  default = "us-east-1a"
}

variable "name_prefix" {
  default = "subnet-demo"
}
