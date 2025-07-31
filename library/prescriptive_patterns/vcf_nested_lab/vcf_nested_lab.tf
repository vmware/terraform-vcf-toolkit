# --------------------------------------------------------------- #
# Configure 'root' vCenter components
# --------------------------------------------------------------- #
module "lab1_infra" {
  source = "../../../../modules/lab/nested_lab_infra"

  # Read top-level vCenter components
  root_datacenter = var.root_datacenter
  root_cluster    = var.root_cluster
  root_datastore  = var.root_datastore
  root_vds        = var.root_vds

  # Create top-level vCenter components
  root_rp     = var.root_rp
  root_folder = var.root_folder
}

# --------------------------------------------------------------- #
# Deploy # Nested ESXi hosts
# --------------------------------------------------------------- #
module "lab1_hosts" {
  source     = "../../../../modules/lab/nested_lab_rack"
  depends_on = [module.lab1_rack1_infra]

  # Read top-level vCenter components
  root_datacenter = var.root_datacenter
  root_cluster    = var.root_cluster
  root_datastore  = var.root_datastore
  root_vds        = var.root_vds
  root_host       = var.root_host

  # Read top-level vCenter components
  root_rp     = var.root_rp
  root_folder = var.root_folder

  # Deploy nested ESXi host(s)
  esxi_template  = var.esxi_template
  nested_hosts   = var.nested_hosts["rack1"]
  nested_lab_pg  = var.nested_lab_pg
  data_disk_size = var.data_disk_size

  # vApp Config
  dns                     = var.lab_dns
  ntp                     = var.lab_ntp
  search_domain           = var.search_domain
  passwords               = var.passwords
  management_network_info = var.management_network_info["rack1"]
}

# --------------------------------------------------------------- #
# Optional Router to avoid network underlay config
# --------------------------------------------------------------- #
/*
module "lab1_router" {
  source     = "../../../../modules/lab/router_vyos"
  depends_on = [module.lab1_rack1_infra]

  # vCenter target Cluster for VyOS Router VM deployment
  datacenter      = var.root_datacenter
  cluster         = var.root_cluster
  deployment_host = var.deployment_host
  datastore       = var.root_datastore
  vds             = var.root_vds
  folder          = var.root_folder
  resource_pool   = var.root_rp

  local_ova_path = var.local_ova_path["vyos"]
  vm_settings    = var.vm_settings
  internal_pg    = var.internal_pg
  external_pg    = var.external_pg
  vyos_config    = var.vyos_config
}
*/
# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "lab1" {
  value = [
    module.lab1_infra,
    module.lab1_hosts,
    #module.lab1_router
  ]
}