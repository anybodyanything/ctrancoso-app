variable "image_ref" {
  type = string
}

variable "db_secret_name" {
  type = string
  default = "postgres-secret"
}

variable "namespace" {
  type    = string
  default = "default"
}