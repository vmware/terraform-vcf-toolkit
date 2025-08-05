provider "vcf" {
  cloud_builder_host     = ""
  cloud_builder_username = "admin"
  cloud_builder_password = ""
  allow_unverified_tls   = true
}

module "bringup" {
  source = "../../../modules/vcf/bringup_5.2.1"
  # --------------------------------------------------------------- #
  # Environment
  # --------------------------------------------------------------- #
  domain_suffix = ""
  dns           = ["", ""]
  ntp           = ["", ""]
  #
  license_keys = {
    nsx     = ""
    vcenter = ""
    vsan    = ""
    esxi    = ""
  }
  #
  ceip = "true"
  # --------------------------------------------------------------- #
  # Network Pools
  # --------------------------------------------------------------- #
  network_pool_mgmt_appliances = {
    subnet_cidr     = ""
    gateway         = ""
    vlan            = ""
    mtu             = 1500
    port_group_name = "mgmt_appliances"
  }
  #
  network_pool_mgmt_esxi = {
    subnet_cidr     = ""
    gateway         = ""
    vlan            = ""
    mtu             = 1500
    port_group_name = "esxi"
  }
  #
  network_pool_mgmt_vmotion = {
    subnet_cidr     = ""
    gateway         = ""
    vlan            = ""
    mtu             = 1500
    port_group_name = "vmotion"
    range_start     = ""
    range_end       = ""
  }
  #
  network_pool_mgmt_vsan = {
    subnet_cidr     = ""
    gateway         = ""
    vlan            = ""
    mtu             = 1500
    port_group_name = "vsan"
    range_start     = ""
    range_end       = ""
  }
  #
  network_pool_mgmt_tep = {
    subnet_cidr     = ""
    gateway         = ""
    vlan            = ""
    mtu             = 1700
    port_group_name = "host_tep"
    range_start     = ""
    range_end       = ""
    tz_overlay_name = "tz-overlay"
  }
  # --------------------------------------------------------------- #
  # vCenter
  # --------------------------------------------------------------- #
  psc_domain = {
    name           = ""
    admin_password = ""
  }
  #
  vcenter = {
    size          = "medium"
    name          = ""
    ip            = ""
    datacenter    = "datacenter01"
    root_password = "VMware1!VMware1!"

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
    vip  = ""
    fqdn = ""
    passwords = {
      admin = "VMware1!VMware1!"
      root  = "VMware1!VMware1!"
      audit = "VMware1!VMware1!"
    }
    transport_zone_name = "cl01_tz_overlay"
    transport_zone_vlan = "number"
  }
  # --------------------------------------------------------------- #
  # SDDC Manager
  # --------------------------------------------------------------- #
  sddc_manager = {
    name = ""
    ip   = ""
    passwords = {
      root     = "VMware1!VMware1!"
      vcf_user = "VMware1!VMware1!"
    }
  }
  # --------------------------------------------------------------- #
  # Management Cluster
  # --------------------------------------------------------------- #
  cluster_config = {
    name = ""
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
    "fqdn1" = ["ip", "netmask", "gateway", "VMware1!VMware1!"]
    "fqdn2" = ["ip", "netmask", "gateway", "VMware1!VMware1!"]
    "fqdn3" = ["ip", "netmask", "gateway", "VMware1!VMware1!"]
    "fqdn4" = ["ip", "netmask", "gateway", "VMware1!VMware1!"]
  }
}