# --------------------------------------------------------------- #
# VCF Host Commission process
# - Hosts must meet the required vSphere versioning.
# --------------------------------------------------------------- #
module "host_commission" {
  source = "../../../../modules/vcf/host_commission"

  network_pool = var.network_pool
  hosts        = var.host
}

# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "hosts" {
  value = module.host_commission
}