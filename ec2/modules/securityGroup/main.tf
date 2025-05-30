# Criar security groups
resource "aws_security_group" "this" {
  for_each = var.security_groups

  name        = "${var.name_prefix}-${each.value.name}"
  description = each.value.description
  vpc_id      = var.vpc_demo_id

  tags = merge(
    var.tags,
    each.value.tags,
    {
      Name = "${var.name_prefix}-${each.value.name}"
      Type = "Security Group"
    }
  )
}

# Criar regras de ingress separadamente para melhor flexibilidade
resource "aws_security_group_rule" "ingress" {
  for_each = {
    for rule_key, rule_value in local.all_ingress_rules :
    rule_key => rule_value if rule_value.rule.self != true
  }

  type              = "ingress"
  security_group_id = aws_security_group.this[each.value.sg_key].id

  description = each.value.rule.description
  from_port   = each.value.rule.from_port
  to_port     = each.value.rule.to_port
  protocol    = each.value.rule.protocol

  # Usar cidr_blocks OU source_security_group_id, nunca ambos
  cidr_blocks = each.value.rule.source_security_group_id != null ? null : each.value.rule.cidr_blocks

  source_security_group_id = each.value.rule.source_security_group_id != null ? (
    each.value.rule.source_security_group_id != "" ?
    aws_security_group.this[each.value.rule.source_security_group_id].id :
    each.value.rule.source_security_group_id
  ) : null
}

# Criar regras de ingress com self separadamente
resource "aws_security_group_rule" "ingress_self" {
  for_each = {
    for rule_key, rule_value in local.all_ingress_rules :
    rule_key => rule_value if rule_value.rule.self == true
  }

  type              = "ingress"
  security_group_id = aws_security_group.this[each.value.sg_key].id

  description = each.value.rule.description
  from_port   = each.value.rule.from_port
  to_port     = each.value.rule.to_port
  protocol    = each.value.rule.protocol

  self = true
}

# Criar regras de egress separadamente
resource "aws_security_group_rule" "egress" {
  for_each = {
    for rule_key, rule_value in local.all_egress_rules :
    rule_key => rule_value if rule_value.rule.self != true
  }

  type              = "egress"
  security_group_id = aws_security_group.this[each.value.sg_key].id

  description = each.value.rule.description
  from_port   = each.value.rule.from_port
  to_port     = each.value.rule.to_port
  protocol    = each.value.rule.protocol

  # Usar cidr_blocks OU source_security_group_id, nunca ambos
  cidr_blocks = each.value.rule.destination_security_group_id != null ? null : each.value.rule.cidr_blocks

  source_security_group_id = each.value.rule.destination_security_group_id != null ? (
    each.value.rule.destination_security_group_id != "" ?
    aws_security_group.this[each.value.rule.destination_security_group_id].id :
    each.value.rule.destination_security_group_id
  ) : null
}

# Criar regras de egress com self separadamente
resource "aws_security_group_rule" "egress_self" {
  for_each = {
    for rule_key, rule_value in local.all_egress_rules :
    rule_key => rule_value if rule_value.rule.self == true
  }

  type              = "egress"
  security_group_id = aws_security_group.this[each.value.sg_key].id

  description = each.value.rule.description
  from_port   = each.value.rule.from_port
  to_port     = each.value.rule.to_port
  protocol    = each.value.rule.protocol

  self = true
}

# ========================================
# LOCALS PARA PROCESSAR REGRAS
# ========================================

locals {
  # Flatten todas as regras de ingress
  all_ingress_rules = merge([
    for sg_key, sg_config in var.security_groups : {
      for rule_key, rule_config in sg_config.ingress_rules :
      "${sg_key}-${rule_key}" => {
        sg_key = sg_key
        rule   = rule_config
      }
    }
  ]...)

  # Flatten todas as regras de egress
  all_egress_rules = merge([
    for sg_key, sg_config in var.security_groups : {
      for rule_key, rule_config in sg_config.egress_rules :
      "${sg_key}-${rule_key}" => {
        sg_key = sg_key
        rule   = rule_config
      }
    }
  ]...)
}