provider "aws" {
  region = "us-east-1"
}

variable "host_key" {
  default = "k8s_key"
}