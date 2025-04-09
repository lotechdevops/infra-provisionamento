variable "name_prefix" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "node_groups" {
  type = map(object({
    instance_types    = list(string)
    desired_size      = number
    min_size          = number
    max_size          = number
    subnets           = list(string)
    capacity_type     = string
    node_role_arn     = string
    security_group_id = string
  }))
}
