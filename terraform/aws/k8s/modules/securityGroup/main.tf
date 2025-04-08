resource "aws_security_group" "k8s_sg_master" {
  name   = "${var.name_prefix_master}-sg"
  vpc_id = var.vpc_k8s

  dynamic "ingress" {
    for_each = var.sg_ingress_master
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.sg_egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name = "${var.name_prefix_master}-sg"
  }
}

resource "aws_security_group" "k8s_sg_nodes" {
  name   = "${var.name_prefix_nodes}-sg"
  vpc_id = var.vpc_k8s

  dynamic "ingress" {
    for_each = var.sg_ingress_nodes
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol

      cidr_blocks              = try(ingress.value.cidr_blocks, null)
      security_groups          = try([ingress.value.source_security_group_id], null)
    }
  }

  dynamic "egress" {
    for_each = var.sg_egress
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name = "${var.name_prefix_nodes}-sg"
  }
}
