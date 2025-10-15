module "vcf_bringup" {
  source = "git://https://github.com/vmware/terraform-vcf-toolkit/tree/main/modules/vcf/bringup_9.0.1?ref=main"

  providers = {
    vcf = vcf.nested
  }

  vcf_version = "9.0.1"

  domain_suffix = "vcf.lab"
  dns = ["dns_ip_1", "dns_ip_2"]
  ntp = ["ntp_ip_1", "ntp_ip_2"]

  network_pool_mgmt_appliances = {
    subnet_cidr     = "10.192.193.0/24"
    gateway         = "10.192.193.1"
    vlan            = "2158"
    mtu             = "9000"
    port_group_name = "vcf_mgmt_appliances"
  }

  network_pool_mgmt_esxi = {
    subnet_cidr     = "10.192.192.0/24"
    gateway         = "10.192.192.1"
    vlan            = "0"
    mtu             = "9000"
    port_group_name = "esxi"
  }

  network_pool_mgmt_vmotion = {
    subnet_cidr     = "10.192.195.0/24"
    gateway         = "10.192.195.1"
    vlan            = "2159"
    mtu             = "9000"
    port_group_name = "vmotion"
    range_start     = "10.192.195.31"
    range_end       = "10.192.195.40"
  }

  network_pool_mgmt_vsan = {
    subnet_cidr     = "44.129.199.0/24"
    gateway         = "44.129.199.1"
    vlan            = "2160"
    mtu             = "9000"
    port_group_name = "vsan"
    range_start     = "44.129.199.31"
    range_end       = "44.129.199.40"
  }

  network_pool_mgmt_tep = {
    subnet_cidr     = "10.192.194.0/24"
    gateway         = "10.192.194.1"
    vlan            = "2163"
    mtu             = "9000"
    port_group_name = "host_tep"
    range_start     = "10.192.194.128"
    range_end       = "10.192.194.160"
    tz_overlay_name = "nsx-overlay-transportzone"
  }

  vcenter = {
    size          = "medium"
    hostname      = "vcenter-mgmt"
    root_password = "VMware1!VMware1!"
    storage_size  = "lstorage"
  }

  nsx_cluster_appliances = [
    "nsx01-mgmt",
    "nsx02-mgmt",
    "nsx03-mgmt"
  ]

  nsx_cluster_settings = {
    size     = "medium"
    vip_fqdn = "nsx-mgmt.vcf.lab"
    passwords = {
      admin = "VMware1!VMware1!"
      root  = "VMware1!VMware1!"
      audit = "VMware1!VMware1!"
    }
    transport_zone_vlan = 2163
  }

  sddc_manager = {
    hostname = "sddc"
    passwords = {
      root  = "VMware1!VMware1!"
      local = "VMware1!VMware1!"
      ssh   = "VMware1!VMware1!"
    }
  }

  cluster_config = {
    name            = "mgmt-cluster"
    datacenter_name = "mgmt-dc"
    vsan = {
      name  = "mgmt-vsan"
      esa   = true
      ftt   = 1
      dedup = false
    }
  }

  dvs = {
    name = "mgmt-dvs"
    mtu  = "9000"
    uplink_mapping = [
      {
        uplink = "uplink1"
        vmnic  = "vmnic0"
      },
      {
        uplink = "uplink2"
        vmnic  = "vmnic1"
      }
    ]
    nsx_mode = "ENS_INTERRUPT"
  }

  nioc_profiles = {
    MANAGEMENT     = "NORMAL"
    VMOTION        = "LOW"
    VSAN           = "HIGH"
    VIRTUALMACHINE = "HIGH"
    NFS            = "LOW"
    FAULTTOLERANCE = "LOW"
    ISCSI          = "LOW"
    VDP            = "LOW"
    HBR            = "LOW"
  }

  hosts = {
    "nested-esxi-1.vcf.lab" = ["root", "VMware1!VMware1!"]
    "nested-esxi-2.vcf.lab" = ["root", "VMware1!VMware1!"]
    "nested-esxi-3.vcf.lab" = ["root", "VMware1!VMware1!"]
    "nested-esxi-4.vcf.lab" = ["root", "VMware1!VMware1!"]
  }
/*
  fleet_manager = {
    hostname       = "vcf-fleetmanager.vcf.lab"
    admin_password = "VMware1!VMware1!"
    root_password  = "VMware1!VMware1!"
  }

  operations_nodes = {
    admin_password = "VMware1!VMware1!"
    vip_fqdn       = "vcf-operations.vcf.lab"
    nodes = [
      {
        hostname           = "vcf-operations-master.vcf.lab"
        root_user_password = "VMware1!VMware1!"
        type               = "master"
      },
      {
        hostname           = "vcf-operations-data.vcf.lab"
        root_user_password = "VMware1!VMware1!"
        type               = "data"
      },
      {
        hostname           = "vcf-operations-replica.vcf.lab"
        root_user_password = "VMware1!VMware1!"
        type               = "replica"
      },
    ]
  }
  
  operations_collector = {
    hostname           = "vcf-operations-collector.vcf.lab"
    root_user_password = "VMware1!VMware1!"
  }

  automation_cluster = {
    hostname       = "vcf-automation.vcf.lab"
    admin_password = "VMware1!VMware1!"
    ip_pool        = ["10.192.193.93", "10.192.193.94", "10.192.193.95", "10.192.193.96"]
    node_prefix    = "vcfa"
  } 
*/
}