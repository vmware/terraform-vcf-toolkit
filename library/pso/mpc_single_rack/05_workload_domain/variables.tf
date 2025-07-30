# --------------------------------------------------------------- #
# Authentication
# --------------------------------------------------------------- #
variable "sddc_manager_host" {}
variable "sddc_manager_username" {}
variable "sddc_manager_password" {}
# --------------------------------------------------------------- #
# Workload Domain
# --------------------------------------------------------------- #
variable "workload_domain_name" {}
variable "vm_management_network" {}
variable "domain_suffix" {}
# --------------------------------------------------------------- #
# Appliances
# --------------------------------------------------------------- #
variable "vcenter" {}
variable "nsx_cluster_appliances" {}
variable "nsx_cluster_settings" {}
# --------------------------------------------------------------- #
# Cluster Config
# --------------------------------------------------------------- #
variable "cluster_config" {}
variable "dvs" {}
variable "ip_pool_host_tep" {}
variable "wld_hosts" {}