output "cluster_name" {
  value = azurerm_kubernetes_cluster.backend-aks.name
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.backend-aks.kube_config
}