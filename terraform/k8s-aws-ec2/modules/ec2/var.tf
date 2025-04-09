variable "instance_type_master" {
  type = string
}

variable "instance_type_worker" {
  type = string
}

variable "worker_count" {
  type = number
}

variable "sg_master_id" {
  type = string
}

variable "sg_nodes_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "host_key" {
  type = string
}
