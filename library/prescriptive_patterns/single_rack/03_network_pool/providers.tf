terraform {
  required_providers {
    vcf = {
      source  = "vmware/vcf"
      version = "0.14.0"
    }
  }
}

provider "vcf" {
  sddc_manager_host      = var.sddc_manager_host
  sddc_manager_username  = var.sddc_manager_username
  cloud_builder_password = var.sddc_manager_password
  allow_unverified_tls   = true
}