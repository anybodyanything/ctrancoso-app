variable "postgres_version" {
  type        = string
  description = "PostegreSQL version"
  default     = "12"
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