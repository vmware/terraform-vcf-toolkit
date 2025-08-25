# --------------------------------------------------------------- #
# MINIMUM VM IP PLAN - EXAMPLE
# - Does not include BGP config / IPs
# --------------------------------------------------------------- #
# router-lab1 = 10.232.130.10 (routable / NAT)
#
# esxi01-lab1 = 10.232.131.11
# esxi02-lab1 = 10.232.131.12
# esxi03-lab1 = 10.232.131.13
# esxi04-lab1 = 10.232.131.14
#
# cb-lab1 = 10.232.132.10
# vc-lab1 = 10.232.132.11
# sddc-lab1 = 10.232.132.12
# nsx-vip-lab1 = 10.232.132.13
# nsx-01-lab1 = 10.232.132.14
# nsx-02-lab1 = 10.232.132.15
# nsx-02-lab1 = 10.232.132.16
#
# edge01-lab1 = 10.232.132.25
# edge02-lab1 = 10.232.132.26
# --------------------------------------------------------------- #
# Root vCenter Variables
# --------------------------------------------------------------- #
vcenter_server   = "server_ip"
vcenter_username = "administrator@vsphere.local"
vcenter_password = "VMware1!VMware1!"
#
root_datacenter = "DC_NAME"
root_cluster    = "CLUSTER_NAME"
root_datastore  = "DS_NAME"
root_rp         = "RP_NAME"
root_folder     = "FOLDER_NAME"
root_host       = "ESXI_HOST_FQDN"
#
root_vds      = "DVS"
nested_lab_pg = "lab_trunk"
# --------------------------------------------------------------- #
# Nested Environment Variables
# --------------------------------------------------------------- #
lab_dns       = "DNS_IP"
lab_ntp       = "NTP_IP"
search_domain = "SEARCH_DOMAIN"
#
esxi_template = "VM_TEMPLATE_NESTED_ESXI"
#
data_disk_size = 1024
nested_hosts = {
  rack1 = {
    "esxi01.fqdn" = "10.232.131.211",
    "esxi02.fqdn" = "10.232.131.212",
    "esxi03.fqdn" = "10.232.131.213",
    "esxi04.fqdn" = "10.232.131.214",
  }
}
#
management_network_info = {
  rack1 = {
    gateway    = "10.232.131.1"
    subnetmask = "255.255.255.0"
    vlan       = "3702"
  }
}
#
passwords = {
  admin = "VMware1!VMware1!"
  root  = "VMware1!VMware1!"
}
# --------------------------------------------------------------- #
# VM Deployment Variables
# --------------------------------------------------------------- #
# Root / Global
datacenter      = "DC"
cluster         = "CLUSTER"
deployment_host = "DEPLOYMENT_HOST_FQDN"
datastore       = "DS_NAME"
vds             = "DSWITCH_NAME"
port_group      = "PORT_GROUP_NAME"
local_ova_path = {
  cloud_builder = "E:\\VMware-Cloud-Builder-5.2.0.0-24353002_OVF10.ova",
  vyos          = "E:\\vyos-1.2.9-S1-cloud-init-vmware.ova"
}

#VyOS Settings
vyos_config = "config.yaml"
external_pg = "PORT_GROUP_NAME"
internal_pg = "PORT_GROUP_NAME"
vm_settings = {
  vm_name       = "VM_NAME"
  domain_suffix = "SEACH_DOMAIN"
  wan_ip        = "ROUTABLE_IP"
  mask          = "SUBNET_MASK"
  gateway       = "GATEWAY_IP"
  dns           = "DNS_IP"
  ntp           = "NTP_IP"
}
# Cloud Builder Settings
cloud_builder_settings = {
  hostname   = "VM_NAME"
  ip         = "IP"
  netmask    = "SUBNET_MASK"
  gateway    = "GATEWAY"
  domain     = "SEARCH_DOMAIN"
  searchpath = "SEARCH_DOMAIN"
  ntp        = "NTP_IP"
  dns        = "DNS_IP"
}
cloud_builder_passwords = {
  admin_user = "admin"
  admin_pass = "VMware1!VMware1!"
  root_pass  = "VMware1!VMware1!"
}
# --------------------------------------------------------------- #
# VCF Bring Up Variables
# --------------------------------------------------------------- #
cloud_builder_host     = "CLOUDBUILDER_FQDN"
cloud_builder_username = "admin"
cloud_builder_password = "VMware1!VMware1!"
#
sddc_passwords = {
  root = "VMware1!VMware1!"
  vcf  = "VMware1!VMware1!"
}
#
domain_suffix = "SEARCH_DOMAIN"
#
vcf_dns = ["DNS_IP"]
#
vcf_ntp = ["DNS_IP"]
#
license_keys = {
  nsx     = ""
  vcenter = ""
  vsan    = ""
  esxi    = ""
}

#
ceip = "false"
#
network_pool_mgmt_appliances = {
  subnet_cidr     = "10.232.132.0/24"
  gateway         = "10.232.132.1"
  vlan            = "3703"
  mtu             = 8000
  port_group_name = "mgmt_appliances"
}
#
network_pool_mgmt_esxi = {
  subnet_cidr     = "10.232.131.0/24"
  gateway         = "10.232.131.1"
  vlan            = "3702"
  mtu             = 8000
  port_group_name = "esxi"
}
#
network_pool_mgmt_vmotion = {
  subnet_cidr     = "10.232.134.0/24"
  gateway         = "10.232.134.1"
  vlan            = "3705"
  mtu             = 8000
  port_group_name = "vmotion"
  range_start     = "10.232.134.200"
  range_end       = "10.232.134.226"
}
#
network_pool_mgmt_vsan = {
  subnet_cidr     = "10.232.133.0/24"
  gateway         = "10.232.133.1"
  vlan            = "3704"
  mtu             = 8000
  port_group_name = "vsan"
  range_start     = "10.232.133.200"
  range_end       = "10.232.133.226"
}
#
network_pool_mgmt_tep = {
  subnet_cidr     = "10.232.135.0/24"
  gateway         = "10.232.135.1"
  vlan            = "3706"
  mtu             = 8000
  port_group_name = "host_tep"
  range_start     = "10.232.135.200"
  range_end       = "10.232.135.226"
  tz_overlay_name = "tz-overlay"
}
#
sso_passwords = {
  vcenter_mgmt = "VMware1!VMware1!"
  psc          = "VMware1!VMware1!"
}
#
mgmt_nsxt_passwords = {
  admin = "VMware1!VMware1!"
  root  = "VMware1!VMware1!"
  audit = "VMware1!VMware1!"
}
#
sddc_manager = {
  name = "SDDC_VM_NAME"
  ip   = "10.232.132.202"
}
#
vcenter_mgmt = {
  size = "small" #tiny for lab
  name = "VC_VM_NAME"
  ip   = "10.232.132.201"
}
#
nsx_mgmt = {
  size            = "medium"
  name            = "nsx-lab1"
  vip             = "10.232.132.203"
  appliance1_name = "nsx01-lab1"
  appliance1_ip   = "10.232.132.204"
  appliance2_name = "nsx02-lab1"
  appliance2_ip   = "10.232.132.205"
  appliance3_name = "nsx03-lab1"
  appliance3_ip   = "10.232.132.206"
}
#
psc_domain = "sddc.lab"
#
mgmt_vc_datacenter_name = "mgmt_dc"
#
mgmt_vc_cluster_name = "mgmt_cluster"
#
mgmt_cluster_vsan_name = "mgmt_vsan"
#
mgmt_vc_dvs = {
  name    = "mgmt_dvs"
  version = "8.0.0"
  mtu     = "8000"
  uplinks = ["vmnic0", "vmnic1", "vmnic2", "vmnic3"]
}
#
standard_switch_name = "vSwitch0"
#
hosts = {
  "esxi01.fqdn" = ["10.232.131.211", "255.255.255.0", "10.232.132.1", "VMware1!VMware1!"]
  "esxi02.fqdn" = ["10.232.131.212", "255.255.255.0", "10.232.132.1", "VMware1!VMware1!"]
  "esxi03.fqdn" = ["10.232.131.213", "255.255.255.0", "10.232.132.1", "VMware1!VMware1!"]
  "esxi04.fwdn" = ["10.232.131.214", "255.255.255.0", "10.232.132.1", "VMware1!VMware1!"]
}