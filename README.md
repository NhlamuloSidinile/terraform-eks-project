🚀 EKS Platform Production (v1.35)
A production-ready Kubernetes platform built on Amazon EKS 1.35, leveraging Terraform for Infrastructure as Code and Argo CD for GitOps-driven deployments.

🏗️ Architecture Overview
Cloud Provider: AWS (eu-west-1)

Kubernetes Version: 1.35

Node Runtime: Amazon Linux 2023 (AL2023)

Provisioning: Terraform with EKS Access Entries (API-based auth)

CD/GitOps: Argo CD (Helm-managed)

Network: VPC with Private Subnets and NAT Gateways

🛠️ Tech Stack
IaC: Terraform v1.x+

Orchestration: Amazon EKS

Nodes: Managed Node Groups (t3.micro)

Monitoring/TUI: K9s

Add-ons: VPC CNI, CoreDNS, Kube-Proxy

🚀 Getting Started
1. Prerequisites
Ensure your environment has the following installed:

AWS CLI configured with appropriate permissions.

Terraform CLI.

kubectl and helm.

2. Infrastructure Provisioning
Bash
# Initialize Terraform providers
terraform init

# Review the infrastructure plan
terraform plan

# Deploy the cluster and networking
terraform apply -auto-approve
3. Cluster Access
After deployment, update your local kubeconfig to point to the new 1.35 control plane:

Bash
aws eks update-kubeconfig --region eu-west-1 --name eks-platform-prod-eks
Note: Access is managed via EKS Access Entries. Ensure your IAM role is mapped to the AmazonEKSClusterAdminPolicy.

🎡 GitOps with Argo CD
Argo CD is the source of truth for all applications running on this cluster.

Accessing the Dashboard
Get the LoadBalancer URL:

Bash
kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
Get Admin Password:

Bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
📂 Repository Structure
Plaintext
.
├── terraform/          # IaC for VPC, EKS, and IAM
│   ├── main.tf         # Core EKS & Access Entry definitions
│   ├── vpc.tf          # Networking layer
│   └── variables.tf    # Configurable parameters
├── charts/             # Custom Helm charts for applications
└── argocd/             # Argo CD Application manifests (App-of-Apps)
🛡️ Security & Compliance
Private Networking: All worker nodes reside in private subnets.

IMDSv2: Enforced on all EC2 instances for metadata security.

RBAC: Leverages EKS Access Management API (v1.31+) for granular cluster permissions.

Author: Nhlamulo Sidinile
Role: Cloud DevOps Engineer / Platform Architect
