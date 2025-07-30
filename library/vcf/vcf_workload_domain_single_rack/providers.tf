terraform {
  required_providers {
    vcf = {
      source  = "vmware/vcf"
      version = "0.13.0"
    }
  }
}

provider "vcf" {
  sddc_manager_host     = ""
  sddc_manager_username = ""
  sddc_manager_password = ""
  allow_unverified_tls  = true
}