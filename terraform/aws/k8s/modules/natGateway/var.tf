variable "k8s_nat_eip_name" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "natgateway_name" {
  type = string
}
