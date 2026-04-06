
locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "terraform"
  }
}

module "vpc" {
  source = "./vpc"

  vpc_cidr     = var.vpc_cidr
  environment  = var.environment
  project_name = var.project_name
  region       = var.region
  common_tags  = local.common_tags
}

module "eks" {
  source = "./eks"

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

