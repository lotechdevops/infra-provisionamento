# ========================================
# OUTPUTS PRINCIPAIS
# ========================================

output "security_group_ids" {
  description = "Mapa de security group names para seus IDs"
  value = {
    for key, sg in aws_security_group.this :
    key => sg.id
  }
}

output "security_group_details" {
  description = "Detalhes completos dos security groups"
  value = {
    for key, sg in aws_security_group.this :
    key => {
      id          = sg.id
      name        = sg.name
      description = sg.description
      vpc_id      = sg.vpc_id
      arn         = sg.arn
    }
  }
}

# ========================================
# OUTPUTS ÚTEIS PARA REFERÊNCIA
# ========================================

output "security_group_names" {
  description = "Lista de nomes dos security groups criados"
  value       = [for sg in aws_security_group.this : sg.name]
}

output "ingress_rules_count" {
  description = "Número total de regras de ingress criadas"
  value       = length(aws_security_group_rule.ingress)
}

output "egress_rules_count" {
  description = "Número total de regras de egress criadas"
  value       = length(aws_security_group_rule.egress)
}

output "security_groups_summary" {
  description = "Resumo dos security groups criados"
  value = {
    for key, sg in aws_security_group.this :
    key => {
      name          = sg.name
      id            = sg.id
      ingress_rules = length([for rule_key, rule in local.all_ingress_rules : rule if rule.sg_key == key])
      egress_rules  = length([for rule_key, rule in local.all_egress_rules : rule if rule.sg_key == key])
    }
  }
}