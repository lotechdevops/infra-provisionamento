variable "instance_type_master" {
  type = string
}

variable "subnet_private" {
  type = string
}

variable "instance_type_worker" {
  type = string
}

variable "worker_count" {
  type = number
}

variable "host_key" {
  type = string
}

variable "k8s_sg_id" {
  type = string
}