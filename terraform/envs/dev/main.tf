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
  source = "../../modules/kubernetes_service"
  cluster_name = var.cluster_name
  dns_prefix = var.dns_prefix
  kubernetes_version = var.kubernetes_version
  location = var.location
  resource_group_name = var.resource_group_name
}