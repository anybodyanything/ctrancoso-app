resource "azurerm_key_vault" "key_vault" {
  location            = var.location
  name                = var.name
  resource_group_name = var.resource_group_name

  sku_name  = "standard"
  tenant_id = var.tenant_id

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  #RBAC: access control by roles
  enable_rbac_authorization = true
}