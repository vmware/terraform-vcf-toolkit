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
  name     = var.pool
}

resource "vcf_host" "host" {
  depends_on = [data.vcf_network_pool.pool_id]
  for_each   = { for host, h in var.hosts : h.fqdn => h }

  fqdn            = each.value.fqdn
  username        = each.value.user
  password        = each.value.password
  storage_type    = each.value.storage_type
  network_pool_name = each.value.network_pool
  #network_pool_id   = data.vcf_network_pool.pool_id[each.key].id
}

# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "host_id" {
  value = values(vcf_host.host).*.id
}