resource "aws_security_group" "bastion_sg" {
  name   = "${var.name_prefix_bastion}-sg"
  vpc_id = var.vpc_demo_id

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