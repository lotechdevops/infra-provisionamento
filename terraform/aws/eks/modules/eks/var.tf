variable "name_prefix" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "cluster_role_arn" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "cluster_security_group_id" {
  type = string
}
