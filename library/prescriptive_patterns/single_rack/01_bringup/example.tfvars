# --------------------------------------------------------------- #
# Cloudbuilder Authentication
# --------------------------------------------------------------- #
cloud_builder_host     = "cloudbuilder.sddc.lab"
cloud_builder_username = "admin"
cloud_builder_password = "VMware1!VMware1!"
# --------------------------------------------------------------- #
# Environment
# --------------------------------------------------------------- #
domain_suffix = "sddc.lab"
dns           = ["172.16.100.5"]
ntp           = ["172.16.100.5"]
#
license_keys = {
  nsx     = ""
  vcenter = ""
  vsan    = ""
  esxi    = ""
}
#
ceip = "false"
# --------------------------------------------------------------- #
# Network Pools
# --------------------------------------------------------------- #
network_pool_mgmt_appliances = {
  subnet_cidr     = "172.16.104.0/24"
  gateway         = "172.16.104.1"
  vlan            = "1004"
  mtu             = 1500
  port_group_name = "mgmt_appliances"
}
#
network_pool_mgmt_esxi = {
  subnet_cidr     = "172.16.100.0/24"
  gateway         = "172.16.100.1"
  vlan            = "1000"
  mtu             = 1500
  port_group_name = "esxi"
}
#
network_pool_mgmt_vmotion = {
  subnet_cidr     = "172.16.101.0/24"
  gateway         = "172.16.101.1"
  vlan            = "1001"
  mtu             = 1500
  port_group_name = "vmotion"
  range_start     = "172.16.101.10"
  range_end       = "172.16.101.20"
}
#
network_pool_mgmt_vsan = {
  subnet_cidr     = "172.16.102.0/24"
  gateway         = "172.16.102.1"
  vlan            = "1002"
  mtu             = 1500
  port_group_name = "vsan"
  range_start     = "172.16.102.10"
  range_end       = "172.16.102.20"
}
#
network_pool_mgmt_tep = {
  subnet_cidr     = "172.16.103.0/24"
  gateway         = "172.16.103.1"
  vlan            = "1003"
  mtu             = 1700
  port_group_name = "host_tep"
  range_start     = "172.16.103.10"
  range_end       = "172.16.103.40"
  tz_overlay_name = "tz-overlay"
}
# --------------------------------------------------------------- #
# vCenter
# --------------------------------------------------------------- #
psc_domain = {
  name           = "sddc.lab"
  admin_password = "VMware1!VMware1!"
}
#
vcenter = {
  size          = "small"
  name          = "mgmt-vc"
  ip            = "172.16.104.12"
  datacenter    = "sddc_lab_dc01"
  root_password = "VMware1!VMware1!"

}
# --------------------------------------------------------------- #
# NSX
# --------------------------------------------------------------- #
nsx_cluster_appliances = {
  vm1 = ["mgmt-nsx1", "172.16.104.14"]
  vm2 = ["mgmt-nsx2", "172.16.104.15"]
  vm3 = ["mgmt-nsx3", "172.16.104.16"]
}
#
nsx_cluster_settings = {
  vip  = "172.16.104.13"
  fqdn = "mgmt-nsx.sddc.lab"
  passwords = {
    admin = "VMware1!VMware1!"
    root  = "VMware1!VMware1!"
    audit = "VMware1!VMware1!"
  }
  transport_zone_name = "cl01_tz_overlay"
  transport_zone_vlan = "1003"
}
# --------------------------------------------------------------- #
# SDDC Manager
# --------------------------------------------------------------- #
sddc_manager = {
  name = "sddc"
  ip   = "172.16.104.11"
  passwords = {
    root     = "VMware1!VMware1!"
    vcf_user = "VMware1!VMware1!"
  }
}
# --------------------------------------------------------------- #
# Management Cluster
# --------------------------------------------------------------- #
cluster_config = {
  name = "cl01"
  vsan = {
    name = "vsan_ds01"
    esa  = false
    ftt  = 1
  }
}
#
vlcm = true
#
dvs = {
  name    = "mgmt_dvs"
  version = "8.0.0"
  mtu     = "1700"
  uplinks = ["vmnic0", "vmnic1"]
}
#
standard_switch_name = "vSwitch0"
#
hosts = {
  "esxi1-r1.sddc.lab" = ["172.16.100.11", "255.255.255.0", "172.16.100.1", "VMware1!VMware1!"]
  "esxi2-r1.sddc.lab" = ["172.16.100.12", "255.255.255.0", "172.16.100.1", "VMware1!VMware1!"]
  "esxi3-r1.sddc.lab" = ["172.16.100.13", "255.255.255.0", "172.16.100.1", "VMware1!VMware1!"]
  "esxi4-r1.sddc.lab" = ["172.16.100.14", "255.255.255.0", "172.16.100.1", "VMware1!VMware1!"]
}