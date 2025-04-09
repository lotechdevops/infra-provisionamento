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