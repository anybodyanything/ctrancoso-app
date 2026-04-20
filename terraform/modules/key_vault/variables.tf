variable "location" {
  type        = string
  description = "Azure region to deploy"
}

variable "name" {
  type        = string
  description = "Name of the Azure Kubernetes Service"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "tenant_id" {
  type = string
}