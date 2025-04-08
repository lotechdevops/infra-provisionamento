
# ☸️ EKS Provisioning com Terraform

Este repositório contém a infraestrutura como código (IaC) necessária para provisionar um cluster **Amazon EKS** completo e modularizado utilizando **Terraform**. Todos os recursos são organizados em módulos reutilizáveis, focando em escalabilidade, clareza e facilidade de manutenção.

---

## 📦 Módulos Incluídos

- `vpc/` – Criação da Virtual Private Cloud.
- `subnets/` – Subnets públicas e privadas em múltiplas AZs.
- `route_table/` – Tabelas de rotas para tráfego público e privado.
- `internet_gateway/` – Gateway para acesso externo.
- `nat_gateway/` – NAT para acesso externo de subnets privadas.
- `security_groups/` – SGs separados para o API Server e os nodes.
- `iam_eks/` – Roles e políticas IAM para EKS e nodes.
- `eks/` – Criação do cluster Kubernetes gerenciado.
- `eks_node_groups/` – Node groups com configuração via `for_each`.
- `eks_addons/` – Add-ons gerenciados oficialmente pelo EKS.

---

## ✅ Pré-requisitos

- Conta AWS com permissões administrativas ou equivalentes.
- [Terraform >= 1.3](https://www.terraform.io/downloads).
- AWS CLI configurado (`aws configure`).
- Kubectl (opcional, para interagir com o cluster).

---

## 🧪 main.tf (root)

Este é o ponto de entrada do projeto, onde os módulos são consumidos de forma integrada:

```hcl
module "vpc" {
  source      = "./modules/vpc"
  vpc_cidr    = local.vpc_config.vpc_cidr
  name_prefix = local.vpc_config.name_prefix
}

module "subnets" {
  source               = "./modules/subnets"
  vpc_id               = module.vpc.vpc_id
  name_prefix          = local.subnet_config.name_prefix
  availability_zones   = local.subnet_config.availability_zones
  private_subnet_cidrs = local.subnet_config.private_subnet_cidrs
  public_subnet_cidrs  = local.subnet_config.public_subnet_cidrs
}

module "routeTable" {
  source             = "./modules/routeTable"
  name_prefix        = local.route_table_config.name_prefix
  vpc_id             = module.vpc.vpc_id
  igw_id             = module.internetGateway.igw_id
  nat_gateway_id     = module.natGateway.nat_gateway_id
  public_subnet_ids  = module.subnets.public_subnets
  private_subnet_ids = module.subnets.private_subnets
}

module "internetGateway" {
  source      = "./modules/internetGateway"
  vpc_id      = module.vpc.vpc_id
  name_prefix = local.igw_config.name_prefix
}

module "natGateway" {
  source           = "./modules/natGateway"
  name_prefix      = local.nat_gateway_config.name_prefix
  public_subnet_id = module.subnets.public_subnets[local.nat_gateway_config.public_subnet_az]
}

module "eks_api_sg" {
  source        = "./modules/securityGroups"
  name_prefix   = local.security_group_config.name_prefix_api
  vpc_id        = module.vpc.vpc_id
  ingress_rules = local.sg_ingress_api
  egress_rules  = local.sg_egress_default
}

module "eks_nodes_sg" {
  source        = "./modules/securityGroups"
  name_prefix   = local.security_group_config.name_prefix_nodes
  vpc_id        = module.vpc.vpc_id
  ingress_rules = local.sg_ingress_nodes
  egress_rules  = local.sg_egress_default
}

module "iamEks" {
  source = "./modules/iamEks"
}

module "eks" {
  source                    = "./modules/eks"
  name_prefix               = local.eks_config.name_prefix
  kubernetes_version        = local.eks_config.kubernetes_version
  cluster_role_arn          = module.iamEks.eks_cluster_role_arn
  cluster_security_group_id = module.eks_api_sg.security_group_id
  public_subnet_ids         = values(module.subnets.public_subnets)
}

module "eksNodeGroups" {
  source       = "./modules/eksNodeGroups"
  name_prefix  = "eks-dev"
  cluster_name = module.eks.cluster_name
  node_groups  = local.eks_node_groups
}

module "eks-addons" {
  source       = "./modules/eks-addons"
  cluster_name = module.eks.cluster_name
  name_prefix  = local.eks_config.name_prefix
  addons       = local.eks_addons_config
}
```

---

## 🚀 Como Provisionar

```bash
terraform init
terraform plan
terraform apply
```

Após a criação, configure o `kubectl` com:

```bash
aws eks update-kubeconfig --region us-east-1 --name eks-dev-cluster
```

---

## 🗂 Estrutura do Projeto

```bash
.
├── main.tf
├── terraform.tfvars
├── variables.tf
├── locals.tf
├── modules/
│   ├── vpc/
│   ├── subnets/
│   ├── routeTable/
│   ├── internetGateway/
│   ├── natGateway/
│   ├── securityGroups/
│   ├── iamEks/
│   ├── eks/
│   ├── eksNodeGroups/
│   └── eks-addons/
```

---

## 🛠 Autor

Feito com 💻 por **@seuuser** — laboratório prático com AWS, Kubernetes e Terraform.



## 📘 Descrição dos Módulos

### 📦 `vpc/`
- **Função:** Cria a VPC principal da infraestrutura.
- **Recursos:** `aws_vpc`
- **Variáveis:**
  - `vpc_cidr` – CIDR da VPC.
  - `name_prefix` – Prefixo para nomeação.
- **Outputs:**
  - `vpc_id`

---

### 📦 `subnets/`
- **Função:** Cria subnets públicas e privadas distribuídas em AZs.
- **Recursos:** `aws_subnet`
- **Variáveis:**
  - `vpc_id`
  - `name_prefix`
  - `availability_zones`
  - `private_subnet_cidrs`
  - `public_subnet_cidrs`
- **Outputs:**
  - `public_subnets` – Map[AZ]SubnetID
  - `private_subnets` – Map[AZ]SubnetID

---

### 📦 `routeTable/`
- **Função:** Cria e associa route tables públicas e privadas.
- **Recursos:** `aws_route_table`, `aws_route_table_association`
- **Variáveis:**
  - `vpc_id`
  - `igw_id`
  - `nat_gateway_id`
  - `public_subnet_ids`
  - `private_subnet_ids`
  - `name_prefix`
- **Outputs:**
  - `public_route_table_id`
  - `private_route_table_id`

---

### 📦 `internetGateway/`
- **Função:** Cria um Internet Gateway associado à VPC.
- **Recursos:** `aws_internet_gateway`
- **Variáveis:**
  - `vpc_id`
  - `name_prefix`
- **Outputs:**
  - `igw_id`

---

### 📦 `natGateway/`
- **Função:** Cria um NAT Gateway com Elastic IP.
- **Recursos:** `aws_nat_gateway`, `aws_eip`
- **Variáveis:**
  - `name_prefix`
  - `public_subnet_id`
- **Outputs:**
  - `nat_gateway_id`
  - `eip_id`

---

### 📦 `securityGroups/`
- **Função:** Cria SGs com regras dinâmicas de entrada e saída.
- **Recursos:** `aws_security_group`, `aws_security_group_rule`
- **Variáveis:**
  - `vpc_id`
  - `name_prefix`
  - `ingress_rules`
  - `egress_rules`
- **Outputs:**
  - `security_group_id`

---

### 📦 `iamEks/`
- **Função:** Cria IAM roles e policies para o EKS Cluster e os nodes.
- **Recursos:** `aws_iam_role`, `aws_iam_role_policy_attachment`
- **Outputs:**
  - `eks_cluster_role_arn`
  - `eks_node_role_arn`

---

### 📦 `eks/`
- **Função:** Provisiona o cluster EKS.
- **Recursos:** `aws_eks_cluster`
- **Variáveis:**
  - `name_prefix`
  - `kubernetes_version`
  - `cluster_role_arn`
  - `public_subnet_ids`
  - `cluster_security_group_id`
- **Outputs:**
  - `cluster_name`
  - `cluster_endpoint`
  - `cluster_ca_certificate`

---

### 📦 `eksNodeGroups/`
- **Função:** Cria múltiplos node groups com `for_each`.
- **Recursos:** `aws_eks_node_group`, `aws_launch_template`
- **Variáveis:**
  - `name_prefix`
  - `cluster_name`
  - `node_groups` (mapa com definições)
- **Outputs:**
  - `node_group_names`

---

### 📦 `eks-addons/`
- **Função:** Instala add-ons oficiais do EKS.
- **Recursos:** `aws_eks_addon`
- **Variáveis:**
  - `cluster_name`
  - `name_prefix`
  - `addons` (mapa com nome e versão)
- **Outputs:**
  - `installed_addons`