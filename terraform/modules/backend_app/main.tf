resource "kubernetes_deployment_v1" "backend" {
  metadata {
    name      = "backend"
    namespace = var.namespace
    labels = {
      app = "backend"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "backend"
        }
      }

      spec {
        container {
          name  = "backend"
          image = var.image_ref

          port {
            container_port = 8080
          }

          readiness_probe {
            http_get {
              path = "/api/health"
              port = 8080
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }

          env {
            name  = "PORT"
            value = "8080"
          }

          env {
            name = "DATABASE_URL"
            value_from {
              secret_key_ref {
                name = var.db_secret_name
                key  = "DATABASE_URL"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "backend" {
  metadata {
    name      = "backend"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "backend"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 8080
    }

    type = "ClusterIP"
  }

  depends_on = [
    kubernetes_deployment_v1.backend
  ]
}