
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "chart_version" {
  description = "ArgoCD Helm chart version"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for ArgoCD"
  type        = string
  default     = "argocd"
}

variable "server_service_type" {
  description = "Service type for ArgoCD server"
  type        = string
  default     = "ClusterIP"
}

variable "enable_ha" {
  description = "Enable High Availability mode for ArgoCD"
  type        = bool
  default     = true
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

