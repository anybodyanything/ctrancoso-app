output "cluster_name" {
  value = azurerm_kubernetes_cluster.backend-aks.name
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.backend-aks.kube_config
}

#identity used to pull ACR images
output "kubelet_object_id" {
  value = azurerm_kubernetes_cluster.backend-aks.kubelet_identity[0].object_id
}