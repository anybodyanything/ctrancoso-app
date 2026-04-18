module "global" {
  source              = "../../modules/global"
  environment         = "dev"
  resource_group_name = "rg-kiwauno-global"
}

module "static_web_app" {
  source              = "../../modules/static_web_app"
  name                = var.static_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_tier            = var.sku_tier
}

module "aks" {
  source              = "../../modules/kubernetes_service"
  cluster_name        = var.cluster_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  location            = var.location
  resource_group_name = var.resource_group_name
}

module "postgres_db" {
  source              = "../../modules/postgres_db"
  server_name         = var.server_name
  location            = var.location
  resource_group_name = var.resource_group_name
  database_name       = var.database_name

  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password

  da_admin_username = var.administrator_login
  db_admin_password = var.administrator_password

  #create map for ip ranges: start and end define the range od allowed IPs
  #we assume the IPs are NOT consecutive, creating one entry per IP
  allowed_ip_ranges = {
    for idx, ip in var.allowed_ip_ranges :
    "aks_${idx}" => {
      start_ip = ip
      end_ip   = ip
    }
  }
}