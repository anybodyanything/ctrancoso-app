#general

variable "resource_group_name" {
  type = string
}

variable "global_region" {
  type    = string
  default = "northeurope"
}

variable "frontend_region" {
  type    = string
  default = "westeurope"
}

variable "sku_tier" {
  type    = string
  default = "Free"
}

#static web app vars
variable "static_app_name" {
  type = string
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

#postgres variables
variable "admin_password" {
  type      = string
  sensitive = true
}

variable "local_ip" {
  type    = string
  default = null
}