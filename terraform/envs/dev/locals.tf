locals {
  project = "kiwauno"
  env     = "dev"
  rg_name = "rg-${local.project}-${local.env}"
  can_destroy = true
}