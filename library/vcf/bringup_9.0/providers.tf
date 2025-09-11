# --------------------------------------------------------------- #
# Providers for Nested ESXi Lab v1.0
# --------------------------------------------------------------- #
terraform {
  required_providers {
    vsphere = {
      source  = "vmware/vcf"
      version = "0.17.1"
    }
  }
}

# --------------------------------------------------------------- #
# vCenter Settings
# --------------------------------------------------------------- #
provider "vcf" {
installer_host = "vcf-installer.fqdn"
installer_password = "VMware1!VMware1!"
installer_username = "admin"
allow_unverified_tls = true # Required for self-signed
}