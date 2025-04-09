
# 🚀 Provisionamento de Cluster Kubernetes com Terraform na AWS

Este projeto contém scripts Terraform para provisionar uma infraestrutura básica de cluster Kubernetes na AWS, utilizando uma abordagem modular. Os recursos incluem rede (VPC, subnets, NAT, IGW), segurança (Security Groups), e instâncias EC2 (Master e Workers), com acesso ao cluster feito de forma segura através do HostBastion.

## 📦 Estrutura

O projeto utiliza um `main.tf` na raiz para orquestrar todos os módulos Terraform. Ele é responsável por:

- Chamar os módulos de rede, segurança, EC2 e HostBastion.
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
├── vars-hostBastion.tf
├── vars-ec2.tf
├── modules/
│   ├── vpc/
│   ├── subnets/
│   ├── routeTable/
│   ├── internetGateway/
│   ├── natGateway/
│   ├── securityGroups/
│   ├── ec2/
│   └── hostBastion/

```


O código está organizado em múltiplos módulos reutilizáveis. Cada módulo representa um componente da infraestrutura:

- `vpc/` – Criação da VPC com DNS habilitado.
- `subnets/` – Subnets públicas e privadas em múltiplas AZs.
- `route_tables/` – Tabelas de rota para permitir comunicação com a internet (IGW e NAT).
- `internet_gateway/` – IGW vinculado à VPC.
- `nat_gateway/` – NAT Gateway com EIP para permitir acesso à internet pelas subnets privadas.
- `security_groups/` – Regras de firewall para os nós do cluster.
- `ec2/` – Instâncias EC2 (spot) para o master e os workers do cluster Kubernetes.
- `hostBastion/`– Instância EC2 utilizada para acessar as instâncias EC2 (Master e Worker) com a chave privada.

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

- **Subnets Públicas**: usadas apenas para o NAT Gateway e HostBastion.
- **Subnets Privadas**: usadas para instâncias de master e worker nodes
- **Instâncias EC2 (Spot)**:
  - Master (1 instância) — Subnet privada
  - Workers (2 instâncias, por padrão) — Subnet privada
  - HostBastion (1 instância) — Subnet pública

## ▶️ Como usar

1. Clone o repositório:
   ```bash
   git clone <URL>
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