variable "cluster_name" {
  type        = string
  description = "Nome do cluster EKS"
}

variable "name_prefix" {
  type        = string
  description = "Prefixo para nomeação dos complementos"
}

variable "addons" {
  type = map(object({
    version = string
  }))
  description = "Mapa com os add-ons e suas versões"
}
