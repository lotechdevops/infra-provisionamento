variable "vpcCidr" {
  description = "CIDR block da VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "vpc_name" {
  description = "Nome da VPC"
  type        = string
  default     = "vpc-demo"
}