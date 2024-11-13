variable "vpc_k8s" {
    type = string
}
variable "subnet_public" {
    type = string
}
variable "subnet_private" {
    type = string
}
variable "igw_name" {
    type = string
}
variable "k8s_natgw" {
    type = string
}
variable "cidr_rt_public" {
  type = string
}
variable "cidr_rt_private" {
  type = string
}
variable "rt_public_name" {
  type = string
}
variable "rt_private_name" {
  type = string
}