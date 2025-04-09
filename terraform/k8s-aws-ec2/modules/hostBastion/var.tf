variable "instance_type_bastion" {
    type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "bastion_sg_id" {
  type = string
}

variable "host_key" {
  type        = string
  description = "Nome da chave SSH usada para acessar a instância bastion"
}