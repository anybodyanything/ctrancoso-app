variable "location" {
  type        = string
  description = "Azure region to deploy"
}

variable "name" {
  type = string
  description = "Name of the Azure Kubernetes Service"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "dns_prefix" {
  type        = string
  description = "DNS prefix for AKS cluster"
}

variable "kubernetes_version" {
  type        = string
  description = "Version of K8S"
}

variable "node_pool_name" {
  type        = string
  description = "Node pool name"
  default     = "default"
}

variable "node_count" {
  type        = number
  description = "Number of nodes"
  default     = 2
}

variable "vm_size" {
  type        = string
  description = "VM's size"
  default     = "Standard_B2s_v2"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
