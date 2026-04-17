terraform {
  backend "azurerm" {
    resource_group_name   = "rg-kiwauno-global"
    storage_account_name  = "kiwaunostorage01"
    container_name        = "tfstate"
    key                   = "prod.terraform.tfstate"
  }
}