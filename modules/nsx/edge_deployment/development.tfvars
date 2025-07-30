fault_domain = {
  fd1 = {
    compute_manager = "wld01-vc.mpc.lab1"
    datacenter      = "dc01"
    cluster         = "cl01"
    datastore       = "cl01-vsan"
    dvs             = "cl01-vds"
    #resource_pool = optional(string, "edge_vms")
    #folder        = optional(string, "edge_vms")
  },
  fd2 = {
    compute_manager = "wld01-vc.mpc.lab1"
    datacenter      = "dc01"
    cluster         = "cl02"
    datastore       = "cl02-vsan"
    dvs             = "cl02-vds"
    #resource_pool = optional(string, "edge_vms")
    #folder        = optional(string, "edge_vms")
  }
}
#
search_domains = ["mpc.lab1"]
dns            = ["172.16.100.5"]
ntp            = ["172.16.100.5"]
#
ip_pool = {
  name     = "ip_pool_rack1"
  cidr     = "172.16.105.0/24"
  gateway  = "172.16.105.1"
  start_ip = "172.16.105.100"
  end_ip   = "172.16.105.120"
}
#
uplink_profile = {
  name = "edge_cluster1"
  vlan = 1005
  mtu  = 1700
}
#
edge_vms = {
  edge-vm1 = {
    mgmt_ip      = "172.16.104.100/24"
    mgmt_gw      = "172.16.104.1"
    uplinks      = ["uplink1", "uplink2"]
    fault_domain = "fd1"
    passwords    = {}
  },
  edge-vm2 = {
    mgmt_ip      = "172.16.104.101/24"
    mgmt_gw      = "172.16.104.1"
    uplinks      = ["uplink1", "uplink2"]
    fault_domain = "fd2"
    passwords    = {}
  }
}
#
edge_cluster_name = "edge_cluster1"
#
port_groups = {
  mgmt  = ["edge_vm_mgmt", 1004]
  tor_a = "trunk_tor_a"
  tor_b = "trunk_tor_b"
}