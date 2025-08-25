# --------------------------------------------------------------- #
# Providers for Nested ESXi Lab v1.0
# --------------------------------------------------------------- #
terraform {
  required_providers {
    vsphere = {
      source  = "vmware/vsphere"
      version = "2.11.0"
    }
  }
}

# --------------------------------------------------------------- #
# vCenter Settings
# --------------------------------------------------------------- #
provider "vsphere" {
  user                 = var.vcenter_username
  password             = var.vcenter_password
  vsphere_server       = var.vcenter_server
  allow_unverified_ssl = true # Required for self-signed
}