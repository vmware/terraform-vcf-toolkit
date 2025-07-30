# --------------------------------------------------------------- #
# Create a new VCF Workload Domain
# --------------------------------------------------------------- #
module "workload_domain" {
  source = "../../../../modules/vcf/workload_domain/static_ip_pool"

  # --------------------------------------------------------------- #
  # Environment
  # --------------------------------------------------------------- #
  workload_domain_name  = var.workload_domain_name
  vm_management_network = var.vm_management_network
  domain_suffix         = var.domain_suffix
  # --------------------------------------------------------------- #
  # Appliances
  # --------------------------------------------------------------- #
  vcenter                = var.vcenter
  nsx_cluster_appliances = var.nsx_cluster_appliances
  nsx_cluster_settings   = var.nsx_cluster_settings
  # --------------------------------------------------------------- #
  # Cluster Config
  # --------------------------------------------------------------- #
  cluster_config   = var.cluster_config
  dvs              = var.dvs
  ip_pool_host_tep = var.ip_pool_host_tep
  wld_hosts        = var.wld_hosts
}

# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "workload_domain" {
  value = module.workload_domain
}