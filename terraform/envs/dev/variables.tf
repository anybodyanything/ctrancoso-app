#general
variable "resource_group_name" {
  type = string
}

variable "global_region" {
  type    = string
  default = "northeurope"
}

variable "sku_tier" {
  type    = string
  default = "Free"
}

#aks vars
variable "cluster_name" {
  type    = string
  default = "ctrancoso-dev-aks-cluster"
}

variable "dns_prefix" {
  type    = string
  default = "dev-aks"
}

variable "kubernetes_version" {
  type    = string
  default = "1.26.0"
}

variable "node_count" {
  type    = number
  default = 2
}

variable "vm_size" {
  type    = string
  default = "Standard_DS2_v2"
}

variable "tags" {
  type    = map(string)
  default = {
    environment = "dev"
    project     = "terraform-aks"
  }
}

variable "grafana_admin_password" {
  type      = string
  sensitive = true
}

#postgres variables
variable "admin_user" {
  type    = string
  default = "pgadmin"
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "zone" {
  type    = string
  default = "1"
}

variable "image_ref" {
  type = string
}

variable "frontend_image_ref" {
  type        = string
  description = "Docker image from static frontend"
}