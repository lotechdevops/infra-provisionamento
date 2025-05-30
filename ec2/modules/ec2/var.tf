variable "vpc_demo_id" {
  type = string
}

variable "instances" {
  description = "Instâncias para criar"
  type = map(object({
    name                        = string
    instance_type              = string
    count                      = number         # Quantidade de instâncias
    subnet_type                = string         # "public" ou "private"
    availability_zones         = list(string)   # Lista de AZs: ["us-east-1a", "us-east-1b"]
    associate_public_ip_address = bool
    security_group_names       = list(string)   # MUDANÇA: usar nomes ao invés de IDs
    key_name                   = string
    user_data                  = optional(string, "")
  }))
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_azs" {
  description = "Mapa de AZ para subnet pública"
  type = map(string)
}

variable "private_subnet_azs" {
  description = "Mapa de AZ para subnet privada"
  type = map(string)
}

variable "security_group_ids_map" {
  description = "Mapa de nomes de security groups para seus IDs"
  type        = map(string)
}

variable "name_prefix" {
  type = string
}