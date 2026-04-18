variable "server_name" {
  type = string
  default = "postgres-server"
}

variable "location" {
  type        = string
  description = "Azure region to deploy"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "sku_name" {
  type = string
  default = "GP_Gen5_2"
}

variable "storage_mb" {
  type    = number
  default = 5120
}

variable "backup_retention_days" {
  type    = number
  default = 7
}

variable "administrator_login" {
  type = string
}

variable "administrator_password" {
  type      = string
  sensitive = true
}

variable "db_name" {
  type = string
  default = "postgres-ctrancoso"
}

variable "postgres_version" {
  type        = string
  description = "PostegreSQL version"
  default     = "13"
}

variable "da_admin_username" {
  type        = string
  description = "Database administrator username"
}

variable "db_admin_password" {
  type        = string
  description = "Database administrator password"
  sensitive   = true
}
variable "allowed_ip_ranges" {
  description = "Map of IP ranges to allow in firewall"
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {}
}


