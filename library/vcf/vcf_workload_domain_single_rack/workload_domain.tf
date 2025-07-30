module "vcf_wld01" {
  source = "../../../modules/vcf/workload_domain_static"

  # --------------------------------------------------------------- #
  # Environment
  # --------------------------------------------------------------- #
  domain_suffix = ""
  #
  license_keys = {
    nsx     = ""
    vcenter = ""
    vsan    = ""
    esxi    = ""
  }
  #
  vm_management_network = {
    gateway     = ""
    subnet_mask = ""
  }
  #
  workload_domain_name = ""
  # --------------------------------------------------------------- #
  # vCenter
  # --------------------------------------------------------------- #
  vcenter = {
    name          = ""
    fqdn          = ""
    ip            = ""
    root_password = ""
    size          = ""
    datacenter    = ""
  }
  # --------------------------------------------------------------- #
  # NSX
  # --------------------------------------------------------------- #
  nsx_cluster_appliances = {
    vm1 = ["vm_name", "ip"]
    vm2 = ["vm_name", "ip"]
    vm3 = ["vm_name", "ip"]
  }
  #
  nsx_cluster_settings = {
    vip  = "ip"
    fqdn = ""
    passwords = {
      admin = "VMware1!VMware1!"
      audit = "VMware1!VMware1!"
    }
    transport_zone_name = ""
  }
  # --------------------------------------------------------------- #
  # Workload Cluster
  # --------------------------------------------------------------- #
  cluster_config = {
    name = ""
    vsan = {
      name = ""
      ftt  = 1
    }
  }
  #
  dvs = {
    name    = ""
    version = "8.0.0"
    mtu     = "1700"
    uplinks = ["vmnic0", "vmnic1"]
  }
  #
  wld_hosts = {
    "fqdn1" = {
      uuid = ""
    host_uplinks = ["vmnic0", "vmnic1"] },
    "fqdn2" = {
      uuid = ""
    host_uplinks = ["vmnic0", "vmnic1"] },
    "fqdn3" = {
      password = "VMware1!VMware1!"
    host_uplinks = ["vmnic0", "vmnic1"] },
    "fqdn4" = {
      uuid = ""
    host_uplinks = ["vmnic0", "vmnic1"] }
  }
  #
  ip_pool_host_tep = {
    subnet_cidr     = "cidr"
    gateway         = ""
    vlan            = ""
    mtu             = 1700
    port_group_name = ""
    range_start     = ""
    range_end       = ""
  }

}