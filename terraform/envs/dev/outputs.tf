output "backend_external_ip" {
  value = try(
    kubernetes_service_v1.backend.status[0].load_balancer[0].ingress[0].ip,
    "pending"
  )
}