module "global" {
  source              = "../../modules/global"
  environment         = "dev"
  resource_group_name = ""
}

module "static_web_app" {
  source              = "../../modules/static_web_app"
  name                = var.static_app_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_tier            = var.sku_tier
}
