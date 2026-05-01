output "server_name" {
  value = azurerm_postgresql_flexible_server.kiwauno_flex_server.name
}

output "db_name" {
  value = azurerm_postgresql_flexible_server_database.kiwano_db.name
}

output "fqdn" {
  value = azurerm_postgresql_flexible_server.kiwauno_flex_server.fqdn
}
