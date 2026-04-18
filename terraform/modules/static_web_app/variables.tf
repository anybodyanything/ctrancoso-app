variable "name" {
  type        = string
  description = "Name of the Azure Static Web App"
}

variable "location" {
  type        = string
  description = "Azure region to deploy"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "sku_tier" {
  type        = string
  description = "SKU tier (Free or Standard)"
  default     = "Free"
}
