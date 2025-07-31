# --------------------------------------------------------------- #
# VCF Bringup of the Management Domain
# --------------------------------------------------------------- #
module "bringup" {
  source = "../../../../modules/vcf/bringup_5.2.1"

  # --------------------------------------------------------------- #
  # Environment
  # --------------------------------------------------------------- #
  domain_suffix = var.domain_suffix
  dns           = var.dns
  ntp           = var.ntp
  license_keys  = var.license_keys
  ceip          = "true"
  # --------------------------------------------------------------- #
  # Network Pools
  # --------------------------------------------------------------- #
  network_pool_mgmt_appliances = var.network_pool_mgmt_appliances
  network_pool_mgmt_esxi       = var.network_pool_mgmt_esxi
  network_pool_mgmt_vmotion    = var.network_pool_mgmt_vmotion
  network_pool_mgmt_vsan       = var.network_pool_mgmt_vsan
  network_pool_mgmt_tep        = var.network_pool_mgmt_tep
  # --------------------------------------------------------------- #
  # vCenter
  # --------------------------------------------------------------- #
  psc_domain = var.psc_domain
  vcenter    = var.vcenter
  # --------------------------------------------------------------- #
  # NSX
  # --------------------------------------------------------------- #
  nsx_cluster_appliances = var.nsx_cluster_appliances
  nsx_cluster_settings   = var.nsx_cluster_settings
  # --------------------------------------------------------------- #
  # SDDC Manager
  # --------------------------------------------------------------- #
  sddc_manager = var.sddc_manager
  # --------------------------------------------------------------- #
  # Management Cluster
  # --------------------------------------------------------------- #
  cluster_config       = var.cluster_config
  vlcm                 = var.vlcm
  dvs                  = var.dvs
  standard_switch_name = var.standard_switch_name
  hosts                = var.hosts
}