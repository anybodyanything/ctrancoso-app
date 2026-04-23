output "service_name" {
  value = kubernetes_service_v1.backend.metadata[0].name
}

output "service_port" {
  value = 80
}