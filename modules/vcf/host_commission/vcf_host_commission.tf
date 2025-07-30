# --------------------------------------------------------------- #
# VCF Host Commission
#
# [] Executes the host commission process in SDDC Manager
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
# VCF - Host Commission
# --------------------------------------------------------------- #
data "vcf_network_pool" "pool_id" {
  name = var.network_pool
}

resource "vcf_host" "host" {
  depends_on = [data.vcf_network_pool.pool_id]
  for_each   = var.hosts

  fqdn            = each.key
  network_pool_id = data.vcf_network_pool.pool_id.id
  username        = each.value.user
  password        = each.value.password
  storage_type    = each.value.storage_type
}

# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "host_id" {
  value = values(vcf_host.host).*.id
}
