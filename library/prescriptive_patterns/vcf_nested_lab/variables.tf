# --------------------------------------------------------------- #
# Authentication
# --------------------------------------------------------------- #
variable "vcenter_server" {}
variable "vcenter_username" {}
variable "vcenter_password" {}

# --------------------------------------------------------------- #
# Infra Config
# --------------------------------------------------------------- #
variable "root_datacenter" {}
variable "root_cluster" {}
variable "root_datastore" {}
variable "root_vds" {}
variable "nested_lab_pg" {}
variable "root_rp" {}
variable "root_folder" {}
variable "root_host" {}

# --------------------------------------------------------------- #
# Nested ESXi Rack Configuration
# --------------------------------------------------------------- #
variable "esxi_template" {}
variable "nested_hosts" {}
variable "data_disk_size" {}
variable "management_network_info" {}
variable "lab_dns" {}
variable "lab_ntp" {}
variable "search_domain" {}
variable "passwords" {}

# --------------------------------------------------------------- #
# VM Placement Configuration
# --------------------------------------------------------------- #
variable "datacenter" {}
variable "deployment_host" {}
variable "cluster" {}
variable "datastore" {}
variable "vds" {}
variable "port_group" {}

# --------------------------------------------------------------- #
# VyOS Router Configuration
# --------------------------------------------------------------- #
#variable "vm_settings" {}
#variable "internal_pg" {}
#variable "external_pg" {}
#variable "vyos_config" {}

# --------------------------------------------------------------- #
# Cloudbuilder Configuration
# --------------------------------------------------------------- #
#variable "local_ova_path" {}
#variable "cloud_builder_settings" {}
#variable "cloud_builder_passwords" {}