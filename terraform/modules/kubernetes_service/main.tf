resource "azurerm_kubernetes_cluster" "backend-aks" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name       = var.node_pool_name
    node_count = var.node_count
    vm_size    = var.vm_size

    upgrade_settings {
      drain_timeout_in_minutes      = 10
      max_surge                     = 1   # nº de nós extra temporários durante upgrade
      node_soak_duration_in_minutes = 30      # tempo que o nó deve estar estável antes de continuar atualizações
    }
  }


  identity {
    type = "SystemAssigned"
  }

  oidc_issuer_enabled = true

  lifecycle {
    prevent_destroy = false
  }

}

