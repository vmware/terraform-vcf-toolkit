# --------------------------------------------------------------- #
# Providers for VCF Cloud Builder VM Deployment
# --------------------------------------------------------------- #
terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~>2.6.1"
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