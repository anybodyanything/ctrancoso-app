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

  server_name = "${local.project}-${local.env}-postgres-server"
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
    host     = module.postgreSQL.fqdn
    user     = var.admin_user
    password = var.admin_password
    db       = module.postgreSQL.db_name
  }

  depends_on = [module.aks]
}

resource "kubernetes_deployment_v1" "app" {
  metadata {
    name = "backend"
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
          image = "your-image:latest"

          env {
            name = "DB_HOST"
            value_from {
              secret_key_ref {
                name = kubernetes_secret_v1.postgres.metadata[0].name
                key  = "host"
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
    name = "backend-service"
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
}