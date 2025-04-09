variable "instance_type_master" {
  default = "t2.medium"
}

variable "instance_type_worker" {
  default = "t2.medium"
}

variable "worker_count" {
  default = 2
}

variable "host_key" {
  default = "key_neto_account"
}

variable "market_type_master" {
  default = "spot"
}

variable "market_type_worker" {
  default = "spot"
}

variable "tag_name_master" {
  default = "k8s_master"
}

variable "tag_name_worker" {
  default = "k8s_worker"
}
