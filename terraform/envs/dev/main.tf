module "resource_group" {
  source      = "../../modules/resource_group"
  location    = var.global_region
  environment = local.env
  name        = local.rg_name
  project     = local.project
}

module "static_web_app" {
  source              = "../../modules/static_web_app"
  name                = "${local.project}-${local.env}-static-web-app"
  location            = var.frontend_region
  resource_group_name = module.resource_group.resource_group_name
  sku_tier            = var.sku_tier

  depends_on = [
    module.resource_group
  ]
}

module "aks" {
  source              = "../../modules/kubernetes_service"
  name                = "${local.project}-${local.env}-aks"
  location            = var.global_region
  resource_group_name = module.resource_group.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  depends_on = [
    module.resource_group
  ]
}

module "postgreSQL" {
  source = "../../modules/postgres_db"

  server_name         = "${local.project}-${local.env}-postgres-server"
  admin_password      = var.admin_password
  admin_user          = "pgadmin"
  db_name             = "${local.project}-${local.env}-database"
  location            = var.global_region
  resource_group_name = module.resource_group.resource_group_name

  depends_on = [
    module.resource_group
  ]
}

resource "kubernetes_secret_v1" "postgres" {
  metadata {
    name = "postgres-secret"
  }

  data = {
    host         = module.postgreSQL.fqdn
    user         = "pgadmin"
    password     = var.admin_password
    db           = module.postgreSQL.db_name
    DATABASE_URL = "postgresql://pgadmin:${var.admin_password}@${module.postgreSQL.fqdn}:5432/${module.postgreSQL.db_name}?sslmode=require"
  }

  depends_on = [
    module.aks,
    module.postgreSQL
  ]
}

variable "image_ref" {
  type = string
}

resource "kubernetes_deployment_v1" "app" {
  metadata {
    name      = "backend"
    namespace = "default"
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
                name = "postgres-secret"
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
    namespace = "default"
  }

  spec {
    selector = {
      app = "backend"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }

  depends_on = [
    kubernetes_deployment_v1.app
  ]
}

module "acr" {
  source              = "../../modules/container_registry"
  name                = "${local.project}${local.env}acr"
  resource_group_name = module.resource_group.resource_group_name
  location            = var.global_region
  sku                 = "Basic"
  admin_enabled       = false
}

#gets the AKS object id to define the role assignment
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_object_id
}