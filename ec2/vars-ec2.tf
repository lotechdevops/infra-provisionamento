# vars-ec2.tf - CONFIGURAÇÃO COMPLETA PARA PRODUÇÃO

variable "instances" {
  default = {
    # Bastion Host - 1 instância pública
    # bastion = {
    #   name                        = "bastion"
    #   count                      = 1
    #   instance_type              = "t3.micro"
    #   subnet_type                = "public"
    #   availability_zones         = ["us-east-1a"]
    #   associate_public_ip_address = true
    #   security_group_names       = ["web"]  # ← Certifique-se que existe
    #   key_name                   = "key_neto_account"
      
    #   user_data = <<-EOF
    #     #!/bin/bash
    #     yum update -y
    #     yum install -y htop tree wget curl
    #     echo "Bastion host configurado!" > /var/log/setup.log
    #   EOF
    # }
    
    # Web Servers - 2 instâncias distribuídas
    web = {
      name                        = "web-server"
      count                      = 4
      instance_type              = "t2.micro"
      subnet_type                = "private"
      availability_zones         = ["us-east-1a", "us-east-1b"]
      associate_public_ip_address = false
      security_group_names       = ["web"]
      key_name                   = "key_neto_account"
      
      user_data = <<-EOF
        #!/bin/bash
        yum update -y
        yum install -y httpd
        systemctl start httpd
        systemctl enable httpd
        
        # Mostrar qual servidor e AZ
        INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
        AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
        echo "<h1>Web Server: $INSTANCE_ID</h1><p>AZ: $AZ</p>" > /var/www/html/index.html
        
        echo "Web server configurado!" > /var/log/setup.log
      EOF
    }
    
    # Database - 1 instância (ou 2 para master/replica)
    # database = {
    #   name                        = "database"
    #   count                      = 1
    #   instance_type              = "t3.medium"
    #   subnet_type                = "private"
    #   availability_zones         = ["us-east-1a"]
    #   associate_public_ip_address = false
    #   security_group_names       = ["web"]  # ← Certifique-se que existe
    #   key_name                   = "SUA_CHAVE_SSH"
      
    #   user_data = <<-EOF
    #     #!/bin/bash
    #     yum update -y
    #     yum install -y mysql-server
    #     systemctl start mysqld
    #     systemctl enable mysqld
        
    #     echo "Database configurado!" > /var/log/setup.log
    #   EOF
    # }
    
    # Load Balancer/Proxy (se necessário)
    # proxy = {
    #   name                        = "proxy"
    #   count                      = 1
    #   instance_type              = "t3.small"
    #   subnet_type                = "public"
    #   availability_zones         = ["us-east-1a"]
    #   associate_public_ip_address = true
    #   security_group_names       = ["web"]       # Pode usar o mesmo SG web
    #   key_name                   = "SUA_CHAVE_SSH"
      
    #   user_data = <<-EOF
    #     #!/bin/bash
    #     yum update -y
    #     yum install -y nginx
    #     systemctl start nginx
    #     systemctl enable nginx
        
    #     echo "Proxy configurado!" > /var/log/setup.log
    #   EOF
    # }
  }
}