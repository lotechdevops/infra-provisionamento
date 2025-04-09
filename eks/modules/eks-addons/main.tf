resource "aws_eks_addon" "this" {
  for_each = var.addons

  cluster_name      = var.cluster_name
  addon_name        = each.key
  addon_version     = each.value.version

  tags = {
    Name = "${var.name_prefix}-${each.key}"
  }
}
