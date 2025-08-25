terraform {
  required_providers {
    vsphere = {
      source = "vmware/vsphere"
    }
  }
}

provider "vsphere" {
  user                 = var.vcenter_username
  password             = var.vcenter_password
  vsphere_server       = var.vcenter_server
  allow_unverified_ssl = true
  api_timeout          = 10
}

provider "nsxt" {
  host     = var.nsx_manager
  username = var.nsx_username
  password = var.nsx_password

  # Principal Identity
  client_auth_cert_file = "mycert.pem"
  client_auth_key_file  = "mykey.pem"

  allow_unverified_ssl  = true # Required for self-signed
  max_retries           = 10
  retry_min_delay       = 5000
  retry_max_delay       = 5000
  retry_on_status_codes = [409, 429, 500, 503, 504]
}