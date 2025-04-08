resource "aws_eks_cluster" "this" {
  name     = "${var.name_prefix}-cluster"
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids              = var.public_subnet_ids
    security_group_ids      = [var.cluster_security_group_id]
    endpoint_private_access = false
    endpoint_public_access  = true
  }

  version = var.kubernetes_version
}
