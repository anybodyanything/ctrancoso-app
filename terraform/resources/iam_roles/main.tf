resource "azurerm_role_assignment" "github_contributor" {
  principal_id         = var.github_principal_id
  scope                = var.resource_group_name
  role_definition_name = "Contributor"
}