# Terraform AWS Infrastructure

Este projeto Terraform cria uma infraestrutura completa na AWS usando módulos reutilizáveis e flexíveis. A arquitetura implementa uma VPC com subnets públicas e privadas, NAT Gateway, Internet Gateway, Route Tables e Security Groups configuráveis.

## 🏗️ Arquitetura

A infraestrutura criada inclui:

- **VPC** - Virtual Private Cloud com CIDR customizável
- **Subnets** - Subnets públicas e privadas em múltiplas AZs
- **Internet Gateway** - Para acesso à internet das subnets públicas
- **NAT Gateway** - Para acesso à internet das subnets privadas
- **Route Tables** - Roteamento para internet e NAT Gateway
- **Security Groups** - Controle de acesso flexível e configurável

## 📋 Pré-requisitos

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configurado
- Credenciais AWS configuradas (via AWS CLI, variáveis de ambiente, ou IAM role)

## 🚀 Como usar

### 1. Clonar o repositório

```bash
git clone git@github.com:lotechdevops/infra-provisionamento.git
cd ec2

### 2. Configurar variáveis

Edite os arquivos de variáveis conforme sua necessidade:

#### `vars-vpc.tf`
```hcl
variable "vpcCidr" {
  default = "192.168.0.0/16"  # Ajuste conforme necessário
}

variable "vpc_name" {
  default = "minha-vpc"
}
```

#### `vars-subnets.tf`
```hcl
variable "public_subnet_cidrs" {
  default = [
    "192.168.1.0/24",
    "192.168.2.0/24"
  ]
}

variable "private_subnet_cidrs" {
  default = [
    "192.168.100.0/24",
    "192.168.200.0/24"
  ]
}
```

#### `vars-securityGroup.tf`
```hcl
variable "security_groups" {
  default = {
    bastion = {
      name = "bastion-sg"
      description = "Security group para Bastion host"
      ingress_rules = {
        ssh = {
          description = "SSH access"
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["SEU-IP/32"]  # Substitua pelo seu IP
        }
      }
      # ... outras configurações
    }
  }
}
```

### 3. Inicializar o Terraform

```bash
terraform init
```

### 4. Planejar a execução

```bash
terraform plan
```

### 5. Aplicar as mudanças

```bash
terraform apply
```

Digite `yes` quando solicitado para confirmar a criação dos recursos.

### 6. Destruir a infraestrutura (quando necessário)

```bash
terraform destroy
```

## 📦 Módulos

### VPC Module
Cria a Virtual Private Cloud principal.

**Recursos criados:**
- aws_vpc

### Subnets Module
Cria subnets públicas e privadas em múltiplas zonas de disponibilidade.

**Recursos criados:**
- aws_subnet (públicas)
- aws_subnet (privadas)

**Características:**
- Suporte a CIDRs específicos ou geração automática
- Distribuição automática entre AZs disponíveis
- Tags padronizadas

### Internet Gateway Module
Cria e anexa um Internet Gateway à VPC.

**Recursos criados:**
- aws_internet_gateway
- aws_internet_gateway_attachment

### NAT Gateway Module
Cria NAT Gateways para acesso à internet das subnets privadas.

**Recursos criados:**
- aws_eip
- aws_nat_gateway

**Características:**
- Suporte a múltiplos NAT Gateways (alta disponibilidade)
- Um Elastic IP por NAT Gateway

### Route Tables Module
Cria e configura tabelas de rota.

**Recursos criados:**
- aws_route_table (pública)
- aws_route_table (privadas)
- aws_route_table_association

**Características:**
- Route table pública: rota para Internet Gateway
- Route tables privadas: rota para NAT Gateway
- Suporte a route tables separadas por AZ

### Security Groups Module
Cria security groups flexíveis e configuráveis.

**Recursos criados:**
- aws_security_group
- aws_security_group_rule

**Características:**
- Múltiplos security groups em uma configuração
- Regras de ingress e egress flexíveis
- Suporte a referências entre security groups
- Self-references para comunicação interna

## ⚙️ Configurações Avançadas

### Alta Disponibilidade

Para configurar alta disponibilidade com múltiplos NAT Gateways:

```hcl
# vars-natGateway.tf
variable "nat_gateway_count" {
  default = 2  # Um por AZ
}

# vars-routeTable.tf
variable "create_separate_route_tables" {
  default = true  # Route table separada por AZ
}
```

### Security Groups Customizados

Exemplo de configuração para aplicação web:

```hcl
variable "security_groups" {
  default = {
    web = {
      name = "web-sg"
      description = "Web servers security group"
      ingress_rules = {
        http = {
          description = "HTTP"
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        https = {
          description = "HTTPS"
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
      egress_rules = {
        all_outbound = {
          description = "All outbound"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
    database = {
      name = "db-sg"
      description = "Database security group"
      ingress_rules = {
        mysql_from_web = {
          description              = "MySQL from web"
          from_port               = 3306
          to_port                 = 3306
          protocol                = "tcp"
          source_security_group_id = "web"
        }
      }
    }
  }
}
```

## 🏷️ Tags

Todas as tags são automaticamente aplicadas usando o padrão:

```hcl
variable "common_tags" {
  default = {
    Terraform   = "true"
    Owner       = "DevOps Team"
    Environment = "dev"
    Project     = "meu-projeto"
  }
}
```