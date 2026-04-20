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
}

module "aks" {
  source              = "../../modules/kubernetes_service"
  name                = "${local.project}-${local.env}-aks"
  location            = var.global_region
  resource_group_name = module.resource_group.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
}

module "postgreSQL" {
  source = "../../modules/postgres_db"

  server_name = "${local.project}-${local.env}-postgres-server"
  admin_password      = var.admin_password
  admin_user          = "pgadmin"
  db_name             = "${local.project}-${local.env}-database"
  location            = var.global_region
  resource_group_name = var.resource_group_name

  local_ip = var.local_ip
}