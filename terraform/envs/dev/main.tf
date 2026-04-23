module "resource_group" {
  source      = "../../modules/resource_group"
  location    = var.global_region
  environment = local.env
  name        = local.rg_name
  project     = local.project
}

# Podes manter este módulo se o challenge pedir SWA criada,
# mas ela deixa de ser a runtime principal da app.
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
    name      = "postgres-secret"
    namespace = "default"
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

module "backend_app" {
  source = "../../modules/backend_app"

  image_ref      = var.image_ref
  db_secret_name = kubernetes_secret_v1.postgres.metadata[0].name

  depends_on = [
    kubernetes_secret_v1.postgres
  ]
}

module "frontend_app" {
  source = "../../modules/frontend_app"

  image_ref = var.frontend_image_ref

  depends_on = [
    module.aks
  ]
}

module "ingress" {
  source = "../../modules/ingress"

  frontend_service_name      = module.frontend_app.service_name
  frontend_service_namespace = "default"
  frontend_service_port      = 80

  backend_service_name      = module.backend_app.service_name
  backend_service_namespace = "default"
  backend_service_port      = module.backend_app.service_port

  depends_on = [
    module.frontend_app
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

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks.kubelet_object_id
}

output "app_url" {
  value = try("http://${module.ingress.ingress_ip}", "pending")
}