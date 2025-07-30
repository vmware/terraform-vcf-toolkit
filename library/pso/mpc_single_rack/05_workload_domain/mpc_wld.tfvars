# --------------------------------------------------------------- #
# Cloudbuilder Authentication
# --------------------------------------------------------------- #
sddc_manager_host     = "sddc.mpc.lab1"
sddc_manager_username = "administrator@mpc.lab1"
sddc_manager_password = "VMware1!VMware1!"
# --------------------------------------------------------------- #
# Environment
# --------------------------------------------------------------- #
domain_suffix = "mpc.lab1"
#
license_keys = {
  nsx     = "MM4L3-DLL93-789CT-0LA26-0WW57"
  vcenter = "H149L-6C1EP-58VNR-0XAHH-3JH2H"
  vsan    = "D14CM-JUF5H-D8KQ9-0UJUE-EHYK0"
  esxi    = "A549L-0XP9H-58LNT-0TWUM-818JH"
}
#
vm_management_network = {
  gateway     = "172.16.104.1"
  subnet_mask = "255.255.255.0"
}
#
workload_domain_name = "wld01"
# --------------------------------------------------------------- #
# vCenter
# --------------------------------------------------------------- #
vcenter = {
  name          = "wld01-vc"
  fqdn          = "wld01-vc.mpc.lab1"
  ip            = "172.16.104.25"
  root_password = "VMware1!VMware1!"
  size          = "small"
  datacenter    = "dc01"
}
# --------------------------------------------------------------- #
# NSX
# --------------------------------------------------------------- #
nsx_cluster_appliances = {
  vm1 = ["wld01-nsx1", "172.16.104.27"]
  vm2 = ["wld01-nsx2", "172.16.104.28"]
  vm3 = ["wld01-nsx3", "172.16.104.29"]
}
#
nsx_cluster_settings = {
  vip  = "172.16.104.26"
  fqdn = "wld01-nsx.mpc.lab1"
  passwords = {
    admin = "VMware1!VMware1!"
    audit = "VMware1!VMware1!"
  }
  transport_zone_name = "cl01_tz_overlay"
}
# --------------------------------------------------------------- #
# Workload Cluster
# --------------------------------------------------------------- #
cluster_config = {
  name = "cl01"
  vsan = {
    name = "vsan_ds01"
    ftt  = 1
  }
}
#
dvs = {
  name    = "cl01_dvs"
  version = "8.0.0"
  mtu     = "1700"
  uplinks = ["vmnic0", "vmnic1"]
}
#
wld_hosts = {
  "esxi5-r1.mpc.lab1" = {
    uuid = "adc8f7b5-f993-4a27-957c-c69772976973"
  host_uplinks = ["vmnic0", "vmnic1"] },
  "esxi6-r1.mpc.lab1" = {
    uuid = "a24163c4-691b-407c-9d58-d5a133cf3821"
  host_uplinks = ["vmnic0", "vmnic1"] },
  "esxi7-r1.mpc.lab1" = {
    uuid = "fb63bc25-e989-4b08-8a10-b3af861b3269"
  host_uplinks = ["vmnic0", "vmnic1"] },
  "esxi8-r1.mpc.lab1" = {
    uuid = "03dc0424-3238-467c-b831-242a14a7d065"
  host_uplinks = ["vmnic0", "vmnic1"] }
}
#
ip_pool_host_tep = {
  subnet_cidr     = "172.16.103.0/24"
  gateway         = "172.16.103.1"
  vlan            = "1003"
  mtu             = 1700
  port_group_name = "host_tep"
  range_start     = "172.16.103.50"
  range_end       = "172.16.103.70"
}