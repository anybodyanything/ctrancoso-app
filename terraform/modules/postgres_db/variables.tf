variable "server_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "admin_user" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "sku_name" {
  type = string
  default = "B_Standard_B1ms"
}

variable "postgres_version" {
  type = string
  default = "14"
}

variable "storage_mb" {
  type = number
  default = 32768
}

variable "db_name" {
  type = string
}

variable "zone" {
  type    = string
  default = null
}

variable "local_ip" {
  type = string
  default = null
}