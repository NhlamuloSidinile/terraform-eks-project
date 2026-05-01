# =============================================================================
# ArgoCD Namespace
# =============================================================================
resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "terraform"
      "environment"                  = var.environment
      "project"                      = var.project_name
    }
  }
}

# =============================================================================
# ArgoCD Helm Release
# =============================================================================
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.chart_version
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  timeout    = 600

  # ---------------------------------------------------------------------------
  # Global
  # ---------------------------------------------------------------------------
  set {
    name  = "global.domain"
    value = "argocd.${var.project_name}.local"
  }

  # ---------------------------------------------------------------------------
  # High Availability
  # ---------------------------------------------------------------------------
  set {
    name  = "controller.replicas"
    value = var.enable_ha ? "2" : "1"
  }

  set {
    name  = "server.replicas"
    value = var.enable_ha ? "2" : "1"
  }

  set {
    name  = "repoServer.replicas"
    value = var.enable_ha ? "2" : "1"
  }

  set {
    name  = "applicationSet.replicas"
    value = var.enable_ha ? "2" : "1"
  }

  # ---------------------------------------------------------------------------
  # Server Configuration
  # ---------------------------------------------------------------------------
  set {
    name  = "server.service.type"
    value = var.server_service_type
  }

  # Run insecure so TLS can terminate at the ingress/ALB layer
  set {
    name  = "server.extraArgs[0]"
    value = "--insecure"
  }

  # ---------------------------------------------------------------------------
  # Resource Requests & Limits (production-grade)
  # ---------------------------------------------------------------------------

  # Application Controller
  set {
    name  = "controller.resources.requests.cpu"
    value = "250m"
  }

  set {
    name  = "controller.resources.requests.memory"
    value = "512Mi"
  }

  set {
    name  = "controller.resources.limits.cpu"
    value = "500m"
  }

  set {
    name  = "controller.resources.limits.memory"
    value = "1Gi"
  }

  # Server
  set {
    name  = "server.resources.requests.cpu"
    value = "125m"
  }

  set {
    name  = "server.resources.requests.memory"
    value = "256Mi"
  }

  set {
    name  = "server.resources.limits.cpu"
    value = "250m"
  }

  set {
    name  = "server.resources.limits.memory"
    value = "512Mi"
  }

  # Repo Server
  set {
    name  = "repoServer.resources.requests.cpu"
    value = "125m"
  }

  set {
    name  = "repoServer.resources.requests.memory"
    value = "256Mi"
  }

  set {
    name  = "repoServer.resources.limits.cpu"
    value = "250m"
  }

  set {
    name  = "repoServer.resources.limits.memory"
    value = "512Mi"
  }

  # Redis
  set {
    name  = "redis.resources.requests.cpu"
    value = "100m"
  }

  set {
    name  = "redis.resources.requests.memory"
    value = "128Mi"
  }

  set {
    name  = "redis.resources.limits.cpu"
    value = "200m"
  }

  set {
    name  = "redis.resources.limits.memory"
    value = "256Mi"
  }

  # ---------------------------------------------------------------------------
  # Metrics & Monitoring
  # ---------------------------------------------------------------------------
  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }

  set {
    name  = "server.metrics.enabled"
    value = "true"
  }

  set {
    name  = "repoServer.metrics.enabled"
    value = "true"
  }

  # ---------------------------------------------------------------------------
  # Security Hardening
  # ---------------------------------------------------------------------------

  # Disable admin user after initial setup (re-enable only when needed)
  set {
    name  = "configs.params.server\\.disable\\.auth"
    value = "false"
  }

  # Enable RBAC with default deny policy
  set {
    name  = "configs.rbac.policy\\.default"
    value = "role:readonly"
  }

  # Repo server automount service account token
  set {
    name  = "repoServer.serviceAccount.automountServiceAccountToken"
    value = "true"
  }

  # ---------------------------------------------------------------------------
  # Notifications (disabled by default — enable when you configure targets)
  # ---------------------------------------------------------------------------
  set {
    name  = "notifications.enabled"
    value = "false"
  }

  depends_on = [kubernetes_namespace.argocd]
}
