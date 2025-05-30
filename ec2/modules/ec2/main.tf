# AMI mais recente do Amazon Linux
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Criar múltiplas instâncias distribuindo pelas AZs
locals {
  # Expandir instâncias baseado na quantidade e distribuir pelas AZs
  all_instances = merge([
    for config_key, config in var.instances : {
      for i in range(config.count) :
      "${config_key}-${i + 1}" => merge(config, {
        instance_name = "${config.name}-${i + 1}"
        instance_key  = config_key
        instance_num  = i + 1
        # Distribuir pelas AZs usando módulo (resto da divisão)
        selected_az   = config.availability_zones[i % length(config.availability_zones)]
        # Resolver IDs dos security groups pelos nomes (versão mais segura)
        resolved_sg_ids = compact([
          for sg_name in config.security_group_names :
          lookup(var.security_group_ids_map, sg_name, null)
        ])
      })
    }
  ]...)
}

# Criar instâncias EC2
resource "aws_instance" "this" {
  for_each = local.all_instances

  ami           = data.aws_ami.amazon_linux.id
  instance_type = each.value.instance_type
  key_name      = each.value.key_name

  # Escolher subnet baseado no tipo e AZ selecionada
  subnet_id = each.value.subnet_type == "public" ? var.public_subnet_azs[each.value.selected_az] : var.private_subnet_azs[each.value.selected_az]
  
  # IP público apenas se solicitado
  associate_public_ip_address = each.value.associate_public_ip_address
  
  # Security groups (IDs resolvidos automaticamente)
  vpc_security_group_ids = length(each.value.resolved_sg_ids) > 0 ? each.value.resolved_sg_ids : null
  
  # User data se fornecido
  user_data = each.value.user_data != "" ? each.value.user_data : null

  tags = {
    Name = "${var.name_prefix}-${each.value.instance_name}"
    Type = "EC2 Instance"
    AZ   = each.value.selected_az
    Group = each.value.instance_key
  }
}