# --------------------------------------------------------------- #
# Providers for Nested ESXi Lab v1.0
# --------------------------------------------------------------- #
terraform {
  required_providers {
    vcf = {
      source  = "vmware/vcf"
      version = "0.17.1"
    }
  }
}

# --------------------------------------------------------------- #
# vCenter Settings
# --------------------------------------------------------------- #
provider "vcf" {
  installer_host       = "vcf_installer_IP_or_FQDN"
  installer_password   = "VMware1!VMware1!"
  installer_username   = "admin@local"
  allow_unverified_tls = true # Required for self-signed
  alias                = "nested"
}