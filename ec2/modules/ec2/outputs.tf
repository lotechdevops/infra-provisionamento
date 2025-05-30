output "instance_ids" {
  description = "Mapa de nomes de instâncias para seus IDs"
  value = {
    for key, instance in aws_instance.this :
    key => instance.id
  }
}

output "instance_details" {
  description = "Detalhes completos das instâncias"
  value = {
    for key, instance in aws_instance.this :
    key => {
      id                = instance.id
      instance_type     = instance.instance_type
      ami               = instance.ami
      availability_zone = instance.availability_zone
      private_ip        = instance.private_ip
      public_ip         = instance.public_ip
      subnet_id         = instance.subnet_id
      key_name          = instance.key_name
    }
  }
}

output "private_ips" {
  description = "Mapa de nomes de instâncias para seus IPs privados"
  value = {
    for key, instance in aws_instance.this :
    key => instance.private_ip
  }
}

output "public_ips" {
  description = "Mapa de nomes de instâncias para seus IPs públicos"
  value = {
    for key, instance in aws_instance.this :
    key => instance.public_ip
  }
}

output "ssh_connections" {
  description = "Comandos SSH para conectar nas instâncias"
  value = {
    for key, instance in aws_instance.this :
    key => {
      command = instance.public_ip != "" ? "ssh -i ~/.ssh/${instance.key_name}.pem ec2-user@${instance.public_ip}" : "ssh -i ~/.ssh/${instance.key_name}.pem ec2-user@${instance.private_ip}"
      ip_type = instance.public_ip != "" ? "public" : "private"
    }
    if instance.key_name != null
  }
}

# # DEBUG: Verificar security groups
# output "debug_security_groups_applied" {
#   description = "Debug: Security groups aplicados a cada instância"
#   value = {
#     for key, instance in aws_instance.this :
#     key => {
#       instance_id = instance.id
#       security_groups = instance.vpc_security_group_ids
#       requested_sg_names = var.instances[key].security_group_names
#       available_sgs = var.security_group_ids_map
#     }
#   }
# }