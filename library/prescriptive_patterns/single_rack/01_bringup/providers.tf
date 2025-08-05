terraform {
  required_providers {
    vcf = {
      source  = "vmware/vcf"
      version = "0.14.0"
    }
  }
}

provider "vcf" {
  cloud_builder_host     = var.cloud_builder_host
  cloud_builder_username = "admin"
  cloud_builder_password = var.cloud_builder_password
  allow_unverified_tls   = true
}