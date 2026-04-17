variable "node_count" {
  type        = number
  description = "Number of AKS nodes"
  default     = 2
}

variable "vm_size" {
  type        = string
  description = "AKS node VM size"
  default     = "Standard_DS2_v2"
}