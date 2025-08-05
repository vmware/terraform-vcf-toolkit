module "cloud_builder" {
  source = "../../../modules/appliances/cloud_builder/local"

  # --------------------------------------------------------------- #
  # Module Configuration
  # --------------------------------------------------------------- #

  # vCenter target Cluster for Cloud Builder VM deployment
  datacenter      = var.datacenter
  cluster         = var.cluster
  deployment_host = var.deployment_host
  datastore       = var.datastore
  vds             = var.vds
  port_group      = var.port_group

  # Cloud Builder appliance settings
  local_ova_path          = var.local_ovf_path
  cloud_builder_settings  = var.cloud_builder_settings
  cloud_builder_passwords = var.cloud_builder_passwords
}