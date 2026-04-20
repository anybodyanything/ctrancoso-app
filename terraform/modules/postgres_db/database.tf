#database as dependencies
resource "azurerm_postgresql_flexible_server_database" "kiwano_db" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.kiwauno_flex_server.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}

# Allow Azure services (AKS, pipelines, etc.)
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_rule" {
  count = 1

  name      = "allow-azure-services"
  server_id = azurerm_postgresql_flexible_server.kiwauno_flex_server.id

  #"0.0.0.0" allows ONLY for Azure services access
  #as hardcoded by Azure itself
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Allow your laptop (dev access)
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_local_rule" {
  count = var.local_ip != null ? 1 : 0

  name      = "allow-my-laptop"
  server_id = azurerm_postgresql_flexible_server.kiwauno_flex_server.id

  start_ip_address = var.local_ip
  end_ip_address   = var.local_ip
}