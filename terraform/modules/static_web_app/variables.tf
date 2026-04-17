variable "storage_account_name" {
  type = string
  default = "name of the storage account for frontend build"
}

variable "container_name" {
  type = string
  description = "Name of the blob container for frontend build"
}