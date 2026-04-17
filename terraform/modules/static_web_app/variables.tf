variable "name" {
  type        = string
  description = "Name of the Azure Static Web App"
}

variable "location" {
  type        = string
  description = "Azure region to deploy the Static Web App"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group for the Static Web App"
}

variable "sku_tier" {
  type        = string
  description = "SKU tier for the Static Web App (Free or Standard)"
  default     = "Free"
}
