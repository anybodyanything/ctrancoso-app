#server as main infraestructure
resource "azurerm_postgresql_flexible_server" "kiwauno_flex_server" {
  name                = var.server_name
  resource_group_name = var.resource_group_name
  location            = var.location

  administrator_login    = var.admin_user
  administrator_password = var.admin_password

  sku_name   = var.sku_name
  version    = var.postgres_version
  storage_mb = var.storage_mb
  zone       = var.zone

  backup_retention_days = 7

  lifecycle {
    ignore_changes = [zone]
    prevent_destroy = false
  }
}