# Security Group Master
resource "aws_security_group" "k8s_sg_master" {
  name   = "${var.name_prefix_master}-sg"
  vpc_id = var.vpc_k8s

  egress {
    description = var.master_rules["egress"].description
    from_port   = var.master_rules["egress"].from_port
    to_port     = var.master_rules["egress"].to_port
    protocol    = var.master_rules["egress"].protocol
    cidr_blocks = var.master_rules["egress"].cidr_blocks
  }

  tags = {
    Name = "${var.name_prefix_master}-sg"
  }
}

# Security Group Nodes
resource "aws_security_group" "k8s_sg_nodes" {
  name   = "${var.name_prefix_nodes}-sg"
  vpc_id = var.vpc_k8s

  egress {
    description = var.node_rules["egress"].description
    from_port   = var.node_rules["egress"].from_port
    to_port     = var.node_rules["egress"].to_port
    protocol    = var.node_rules["egress"].protocol
    cidr_blocks = var.node_rules["egress"].cidr_blocks
  }

  tags = {
    Name = "${var.name_prefix_nodes}-sg"
  }
}

# Security Group Bastion
resource "aws_security_group" "bastion_sg" {
  name   = "${var.name_prefix_bastion}-sg"
  vpc_id = var.vpc_k8s

  ingress {
    description = var.bastion_rules["ssh"].description
    from_port   = var.bastion_rules["ssh"].from_port
    to_port     = var.bastion_rules["ssh"].to_port
    protocol    = var.bastion_rules["ssh"].protocol
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = var.bastion_rules["egress"].description
    from_port   = var.bastion_rules["egress"].from_port
    to_port     = var.bastion_rules["egress"].to_port
    protocol    = var.bastion_rules["egress"].protocol
    cidr_blocks = var.bastion_rules["egress"].cidr_blocks
  }

  tags = {
    Name = "${var.name_prefix_bastion}-sg"
  }
}

# Regras MASTER ingress

resource "aws_security_group_rule" "master_api_from_nodes" {
  type                     = "ingress"
  description              = var.master_rules["api"].description
  from_port                = var.master_rules["api"].from_port
  to_port                  = var.master_rules["api"].to_port
  protocol                 = var.master_rules["api"].protocol
  security_group_id        = aws_security_group.k8s_sg_master.id
  source_security_group_id = aws_security_group.k8s_sg_nodes.id
}

resource "aws_security_group_rule" "master_api_from_bastion" {
  type                     = "ingress"
  description              = var.master_rules["api"].description
  from_port                = var.master_rules["api"].from_port
  to_port                  = var.master_rules["api"].to_port
  protocol                 = var.master_rules["api"].protocol
  security_group_id        = aws_security_group.k8s_sg_master.id
  source_security_group_id = aws_security_group.bastion_sg.id
}

resource "aws_security_group_rule" "master_ssh_from_bastion" {
  type                     = "ingress"
  description              = var.master_rules["ssh"].description
  from_port                = var.master_rules["ssh"].from_port
  to_port                  = var.master_rules["ssh"].to_port
  protocol                 = var.master_rules["ssh"].protocol
  security_group_id        = aws_security_group.k8s_sg_master.id
  source_security_group_id = aws_security_group.bastion_sg.id
}

# Regras NODE ingress

resource "aws_security_group_rule" "node_api_from_master" {
  type                     = "ingress"
  description              = var.node_rules["api"].description
  from_port                = var.node_rules["api"].from_port
  to_port                  = var.node_rules["api"].to_port
  protocol                 = var.node_rules["api"].protocol
  security_group_id        = aws_security_group.k8s_sg_nodes.id
  source_security_group_id = aws_security_group.k8s_sg_master.id
}

resource "aws_security_group_rule" "node_kubelet_from_master" {
  type                     = "ingress"
  description              = var.node_rules["kubelet"].description
  from_port                = var.node_rules["kubelet"].from_port
  to_port                  = var.node_rules["kubelet"].to_port
  protocol                 = var.node_rules["kubelet"].protocol
  security_group_id        = aws_security_group.k8s_sg_nodes.id
  source_security_group_id = aws_security_group.k8s_sg_master.id
}

resource "aws_security_group_rule" "node_dns_tcp_from_master" {
  type                     = "ingress"
  description              = var.node_rules["dns_tcp"].description
  from_port                = var.node_rules["dns_tcp"].from_port
  to_port                  = var.node_rules["dns_tcp"].to_port
  protocol                 = var.node_rules["dns_tcp"].protocol
  security_group_id        = aws_security_group.k8s_sg_nodes.id
  source_security_group_id = aws_security_group.k8s_sg_master.id
}

resource "aws_security_group_rule" "node_dns_udp_from_master" {
  type                     = "ingress"
  description              = var.node_rules["dns_udp"].description
  from_port                = var.node_rules["dns_udp"].from_port
  to_port                  = var.node_rules["dns_udp"].to_port
  protocol                 = var.node_rules["dns_udp"].protocol
  security_group_id        = aws_security_group.k8s_sg_nodes.id
  source_security_group_id = aws_security_group.k8s_sg_master.id
}

resource "aws_security_group_rule" "node_ssh_from_bastion" {
  type                     = "ingress"
  description              = var.node_rules["ssh"].description
  from_port                = var.node_rules["ssh"].from_port
  to_port                  = var.node_rules["ssh"].to_port
  protocol                 = var.node_rules["ssh"].protocol
  security_group_id        = aws_security_group.k8s_sg_nodes.id
  source_security_group_id = aws_security_group.bastion_sg.id
}
