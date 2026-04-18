resource "azurerm_postgresql_server" "postgres-server" {
  name                = var.server_name
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = var.sku_name

  storage_mb                   = var.storage_mb
  backup_retention_days        = var.backup_retention_days
  #this should be true in an real scenario, namely in prod env
  geo_redundant_backup_enabled = false
  #this should be true in an real scenario, it is now cause it's a small db
  auto_grow_enabled            = true

  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_password
  version                      = var.postgres_version
  ssl_enforcement_enabled      = true
}

resource "azurerm_postgresql_database" "postgres-db" {
  name                = var.db_name
  resource_group_name = var.resource_group_name
  server_name         = var.server_name
  charset             = "UTF8"
  collation           = "English_United States.1252"

  # prevent the possibility of accidental data loss
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_postgresql_firewall_rule" "allow_aks" {
  for_each = var.allowed_ip_ranges
  name                = "allow_aks_${each.key}"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_postgresql_server.postgres-server.name
  start_ip_address    = var.allowed_ip_ranges
  end_ip_address      = each.value.end_ip
}