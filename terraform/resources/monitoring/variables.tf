variable "namespace" {
  type    = string
  default = "monitoring"
}

variable "grafana_admin_password" {
  type      = string
  sensitive = true
}