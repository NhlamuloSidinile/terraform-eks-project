
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

module "vpc" {
  source = "./modules/vpc"

  vpc_cidr     = var.vpc_cidr
  environment  = var.environment
  project_name = var.project_name
  region       = var.region
  common_tags  = local.common_tags
}

module "eks" {
  source = "./modules/eks"

  cluster_version     = var.cluster_version
  environment         = var.environment
  project_name        = var.project_name
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  node_instance_types = var.node_instance_types
  node_desired_size   = var.node_desired_size
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size
  common_tags         = local.common_tags
}

module "argocd" {
  source = "./modules/argocd"

  cluster_name        = module.eks.cluster_name
  chart_version       = var.argocd_chart_version
  namespace           = var.argocd_namespace
  server_service_type = var.argocd_server_service_type # Fixed the missing dot here
  enable_ha           = var.argocd_enable_ha
  environment         = var.environment
  project_name        = var.project_name

  depends_on = [module.eks]
}