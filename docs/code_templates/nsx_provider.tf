terraform {
  required_providers {
    nsxt = {
      source  = "vmware/nsxt"
      version = "~>3.6.0"
    }
  }
}
# --------------------------------------------------------------- #
# NSX-T Authentication
# --------------------------------------------------------------- #
provider "nsxt" {
  # Basic Auth
  host     = "ip_address"
  username = "admin"
  password = "VMware1!VMware1!"

  # Principal Identity
  client_auth_cert_file = "mycert.pem"
  client_auth_key_file  = "mykey.pem"

  allow_unverified_ssl  = true # Required for self-signed
  max_retries           = 10
  retry_min_delay       = 5000
  retry_max_delay       = 5000
  retry_on_status_codes = [409, 429, 500, 503, 504]
}