# --------------------------------------------------------------- #
# Authentication
# --------------------------------------------------------------- #
variable "cloud_builder_host" {}
variable "cloud_builder_password" {}
# --------------------------------------------------------------- #
# Environment
# --------------------------------------------------------------- #
variable "domain_suffix" {}
variable "dns" {}
variable "ntp" {}
variable "license_keys" {}
# --------------------------------------------------------------- #
# Network Pools
# --------------------------------------------------------------- #
variable "network_pool_mgmt_appliances" {}
variable "network_pool_mgmt_esxi" {}
variable "network_pool_mgmt_vmotion" {}
variable "network_pool_mgmt_vsan" {}
variable "network_pool_mgmt_tep" {}
# --------------------------------------------------------------- #
# vCenter
# --------------------------------------------------------------- #
variable "psc_domain" {}
variable "vcenter" {}
# --------------------------------------------------------------- #
# NSX
# --------------------------------------------------------------- #
variable "nsx_cluster_appliances" {}
variable "nsx_cluster_settings" {}
# --------------------------------------------------------------- #
# SDDC Manager
# --------------------------------------------------------------- #
variable "sddc_manager" {}
# --------------------------------------------------------------- #
# Management Cluster
# --------------------------------------------------------------- #
variable "cluster_config" {}
variable "vlcm" {}
variable "dvs" {}
variable "standard_switch_name" {}
variable "hosts" {}