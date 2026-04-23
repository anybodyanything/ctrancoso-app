terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "tfstatekiwauno"
    container_name       = "tfstate"
    key                  = "dev.tfstate"
  }
}