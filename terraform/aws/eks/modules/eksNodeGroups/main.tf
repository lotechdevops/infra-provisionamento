resource "aws_launch_template" "eks_nodes" {
  for_each = var.node_groups

  name_prefix = "${var.name_prefix}-${each.key}-lt-"
  image_id    = null

  vpc_security_group_ids = [each.value.security_group_id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name_prefix}-${each.key}"
    }
  }
}

resource "aws_eks_node_group" "this" {
  for_each        = var.node_groups
  cluster_name    = var.cluster_name
  node_group_name = each.key
  node_role_arn   = each.value.node_role_arn
  subnet_ids      = each.value.subnets

  launch_template {
    id      = aws_launch_template.eks_nodes[each.key].id
    version = "$Latest"
  }

  scaling_config {
    desired_size = each.value.desired_size
    min_size     = each.value.min_size
    max_size     = each.value.max_size
  }

  instance_types = each.value.instance_types
  capacity_type  = each.value.capacity_type

  tags = {
    Name = "${var.name_prefix}-${each.key}-nodegroup"
  }

  depends_on = [aws_launch_template.eks_nodes]
}
