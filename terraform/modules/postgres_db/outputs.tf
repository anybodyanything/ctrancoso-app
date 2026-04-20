output "server_name" {
  value = azurerm_postgresql_flexible_server.kiwauno_flex_server.name
}

output "fqdn" {
  value = azurerm_postgresql_flexible_server.kiwauno_flex_server.fqdn
}