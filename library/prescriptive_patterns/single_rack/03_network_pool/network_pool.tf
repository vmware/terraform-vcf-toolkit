module "network_pools" {
  source = "../../../../modules/vcf/network_pool"

  network_pool_name = var.network_pool_name
  network_pool_type = var.network_pool_type
}

# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "network_pools" {
  value = module.networks
}