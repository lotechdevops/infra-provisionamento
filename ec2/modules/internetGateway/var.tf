variable "vpc_demo_id" {
  description = "ID da VPC onde o Internet Gateway será anexado"
  type        = string
}

variable "igw_name" {
  description = "Nome do Internet Gateway"
  type        = string
  default     = "demo-igw"
}

variable "tags" {
  description = "Tags adicionais para aplicar ao Internet Gateway"
  type        = map(string)
  default     = {}
}