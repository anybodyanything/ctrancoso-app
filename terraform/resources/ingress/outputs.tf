output "ingress_ip" {
  value = try(
    helm_release.ingress_nginx.status,
    "pending"
  )
}