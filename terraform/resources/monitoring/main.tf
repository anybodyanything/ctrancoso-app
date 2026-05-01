resource "kubernetes_namespace_v1" "monitoring" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "kube_prometheus_stack" {
  name       = "monitoring"
  namespace  = kubernetes_namespace_v1.monitoring.metadata[0].name
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"

  values = [
    yamlencode({
      grafana = {
        adminPassword = var.grafana_admin_password

        "grafana.ini" = {
          server = {
            root_url            = "%(protocol)s://%(domain)s/grafana"
            serve_from_sub_path = true
          }
        }

        service = {
          type = "ClusterIP"
        }
      }

      prometheus = {
        service = {
          type = "ClusterIP"
        }
      }
    })
  ]

  depends_on = [
    kubernetes_namespace_v1.monitoring
  ]
}

resource "kubernetes_ingress_v1" "grafana" {
  metadata {
    name      = "grafana-ingress"
    namespace = kubernetes_namespace_v1.monitoring.metadata[0].name
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      http {
        path {
          path      = "/grafana"
          path_type = "Prefix"

          backend {
            service {
              name = "monitoring-grafana"

              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.kube_prometheus_stack
  ]
}