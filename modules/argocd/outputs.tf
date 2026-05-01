output "namespace" {
  description = "Namespace where ArgoCD is deployed"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "release_name" {
  description = "Helm release name for ArgoCD"
  value       = helm_release.argocd.name
}

output "release_version" {
  description = "Deployed ArgoCD Helm chart version"
  value       = helm_release.argocd.version
}

output "port_forward_command" {
  description = "Command to access ArgoCD UI via port-forward"
  value       = "kubectl port-forward svc/argocd-server -n ${kubernetes_namespace.argocd.metadata[0].name} [US_SOCIAL_SECURITY_NUMBER]"
}

output "get_password_command" {
  description = "Command to retrieve the initial ArgoCD admin password"
  value       = "kubectl -n ${kubernetes_namespace.argocd.metadata[0].name} get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
}

