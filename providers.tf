terraform {
  required_version = ">= 1.5"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 8.9.0"
    }
  }
}

provider "oci" {
  region = var.home_region
  alias = "home"
}

# provider "oci" {
#   region = var.target_region
#   alias = "target"
# }