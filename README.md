
# Infra Provisionamento

Este repositório contém os scripts **Terraform** utilizados para provisionar ambientes de infraestrutura na AWS, com foco em clusters Kubernetes (via EKS ou EC2) e balanceamento de carga com HAProxy.

## 📁 Estrutura do Repositório

```
infra-provisionamento/
├── eks/               # Provisionamento completo de um cluster EKS
├── haproxy/           # Instância EC2 para HAProxy
└── k8s-aws-ec2/       # Cluster Kubernetes em EC2 (sem EKS)
```

---

## 📦 Módulos

### 🔹 `eks/`

Provisiona um cluster gerenciado EKS na AWS com todos os recursos de rede e segurança necessários:

- VPC e Subnets (públicas e privadas)
- Internet Gateway e NAT Gateway
- Route Tables
- Security Groups
- Cluster EKS
- Node Groups (incluindo suporte para múltiplos grupos)
- Add-ons do EKS (ex: CoreDNS, kube-proxy, etc.)

> Ideal para quem busca alta disponibilidade e integração com os serviços gerenciados da AWS.

---

### 🔹 `haproxy/`

Provisiona uma instância EC2 com as configurações necessárias para instalação do **HAProxy**.

- Criação da instância
- Segurança e acessos configurados via Security Group
- Uso comum: balanceamento de carga para clusters em Kubernetes

---

### 🔹 `k8s-aws-ec2/`

Provisiona a infraestrutura completa para um **cluster Kubernetes manual** em EC2:

- VPC e Subnets (privadas e públicas)
- Internet Gateway e NAT Gateway
- Route Tables
- Security Groups para controle de acesso
- EC2 Master e Workers
- EC2 Bastion Host para acesso via SSH

> Solução ideal para aprendizado e controle total do cluster sem uso de EKS.

---

## 🛠️ Tecnologias Utilizadas

- [Terraform](https://www.terraform.io/)
- [AWS EC2, VPC, EKS](https://aws.amazon.com/)
- HAProxy
- Kubernetes

---

## 🚀 Objetivo

Este repositório tem como foco o **provisionamento da camada de infraestrutura**, servindo como base para a posterior configuração dos serviços com ferramentas como **Ansible**.