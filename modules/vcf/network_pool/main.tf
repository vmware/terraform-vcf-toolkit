# --------------------------------------------------------------- #
# VCF Network Pool - Template
#
# [] Creates any number of  network pools for vMotion, vSAN, NFS or iSCSI
#
# Steven Tumolo - VMW by Broadcom
# --------------------------------------------------------------- #
terraform {
  required_providers {
    vcf = {
      source  = "vmware/vcf"
      version = "0.14.0"
    }
  }
}
# --------------------------------------------------------------- #
# VCF Configuration - Network Pool
# --------------------------------------------------------------- #
resource "vcf_network_pool" "network_pool" {
  name = var.network_pool_name

  dynamic "network" {
    for_each = var.network_pool_type
    content {
      type    = network.key
      subnet  = network.value.subnet
      gateway = network.value.gateway
      mask    = network.value.mask
      vlan_id = network.value.vlan
      mtu     = network.value.mtu

      ip_pools {
        start = network.value.start_ip
        end   = network.value.end_ip
      }
    }
  }
}

# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "network_pool_id" {
  value = vcf_network_pool.network_pool.id
}