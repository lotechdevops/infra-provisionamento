
# 🚀 Provisionamento de Cluster Kubernetes com Terraform na AWS

Este projeto contém scripts Terraform para provisionar uma infraestrutura básica de cluster Kubernetes na AWS, utilizando uma abordagem modular. Os recursos incluem rede (VPC, subnets, NAT, IGW), segurança (Security Groups), e instâncias EC2, com acesso ao cluster feito de forma segura através de rede privada.

## 📦 Estrutura

O projeto utiliza um `main.tf` na raiz para orquestrar todos os módulos Terraform. Ele é responsável por:

- Chamar os módulos de rede, segurança e EC2.
- Definir as dependências e a ordem de criação dos recursos.
- Passar variáveis entre os módulos de forma organizada.

### Arquitetura

```bash
.
├── main.tf
├── vars-vpc.tf
├── vars-subnets.tf
├── vars-routeTable.tf
├── vars-internetGateway.tf
├── vars-natGateway.tf
├── vars-securityGroups.tf
├── vars-ec2.tf
├── modules/
│   ├── vpc/
│   ├── subnets/
│   ├── routeTable/
│   ├── internetGateway/
│   ├── natGateway/
│   ├── securityGroups/
│   ├── ec2/
```


O código está organizado em múltiplos módulos reutilizáveis. Cada módulo representa um componente da infraestrutura:

- `vpc/` – Criação da VPC com DNS habilitado.
- `subnets/` – Subnets públicas e privadas em múltiplas AZs.
- `route_tables/` – Tabelas de rota para permitir comunicação com a internet (IGW e NAT).
- `internet_gateway/` – IGW vinculado à VPC.
- `nat_gateway/` – NAT Gateway com EIP para permitir acesso à internet pelas subnets privadas.
- `security_groups/` – Regras de firewall para os nós do cluster.
- `ec2/` – Instâncias EC2 (spot) para o master e os workers do cluster Kubernetes.

## 🌐 Topologia da Rede

```
Internet
   │
[ IGW ]
   │
[ Subnet Pública ]
       │
    [ NAT Gateway ]
       │
[ Subnet Privada ]───[ EC2 Master ]
                     └───[ EC2 Workers ]
```

- **Subnets Públicas**: usadas apenas para o NAT Gateway
- **Subnets Privadas**: usadas para instâncias de master e worker nodes
- **Instâncias EC2 (Spot)**:
  - Master (1 instância) — Subnet privada
  - Workers (2 instâncias, por padrão) — Subnet privada

## 🔧 Variáveis (Exemplos)

### VPC

```hcl
variable "vpcCidr" {
  default = "192.168.0.0/16"
}

variable "vpc_name" {
  default = "vpc_k8s_dev"
}
```

### Subnets

```hcl
locals {
  subnet_config = {
    name_prefix          = "k8s-dev"
    availability_zones   = ["us-east-1a", "us-east-1b"]
    private_subnet_cidrs = ["192.168.1.0/24", "192.168.2.0/24"]
    public_subnet_cidrs  = ["192.168.101.0/24", "192.168.102.0/24"]
  }
}
```

### Internet Gateway

```hcl
variable "igw_name" {
  default = "k8s-dev-igw"
}
```

### NAT Gateway

```hcl
variable "natgateway_name" {
  default = "k8s-dev-natgw"
}

variable "k8s_nat_eip_name" {
  default = "k8s-dev-nat-eip"
}
```

### Route Tables

```hcl
variable "cidr_rt_public" {
  default = "0.0.0.0/0"
}

variable "rt_public_name" {
  default = "rt-public"
}

variable "cidr_rt_private" {
  default = "0.0.0.0/0"
}

variable "rt_private_name" {
  default = "rt-private"
}
```

### Security Groups

```hcl
locals {
  sg_ingress_master = {
    kube_api = {
      from_port   = 6443
      to_port     = 6443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    kubelet = {
      from_port   = 10250
      to_port     = 10250
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  sg_ingress_nodes = {
    api_server_https = {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      source_security_group_id = null
    },
    kubelet = {
      from_port                = 10250
      to_port                  = 10250
      protocol                 = "tcp"
      source_security_group_id = null
    },
    dns_tcp = {
      from_port                = 53
      to_port                  = 53
      protocol                 = "tcp"
      source_security_group_id = null
    },
    dns_udp = {
      from_port                = 53
      to_port                  = 53
      protocol                 = "udp"
      source_security_group_id = null
    }
  }

  sg_egress_default = {
    all = {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```

### EC2

```hcl
variable "instance_type_master" {
  default = "t2.medium"
}

variable "instance_type_worker" {
  default = "t2.medium"
}

variable "worker_count" {
  default = 2
}
```

As AMIs utilizadas são baseadas no Ubuntu 20.04 (Focal), usando as imagens oficiais da Canonical.

## ▶️ Como usar

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/terraform-k8s-cluster.git
   cd terraform-k8s-cluster
   ```

2. Inicialize o Terraform:
   ```bash
   terraform init
   ```

3. Visualize o plano:
   ```bash
   terraform plan
   ```

4. Provisione os recursos:
   ```bash
   terraform apply
   ```

## 📎 Pré-requisitos

- Conta na AWS com permissões adequadas
- AWS CLI configurado
- Terraform instalado (>= v1.0)

## 📚 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](./LICENSE) para mais detalhes.