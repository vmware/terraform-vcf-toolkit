# --------------------------------------------------------------- #
# Specify Fault-Domain mapping constructs.
#  - Each domain is represented with a map. fd# = {}
# --------------------------------------------------------------- #
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
# --------------------------------------------------------------- #
# NSX environment variables
# --------------------------------------------------------------- #
search_domains = ["mpc.lab1"]
dns            = ["172.16.100.5"]
ntp            = ["172.16.100.5"]

ip_pool = {
  fd1 = {
    name     = "ip_pool_rack1"
    cidr     = "172.16.105.0/24"
    gateway  = "172.16.105.1"
    start_ip = "172.16.105.100"
    end_ip   = "172.16.105.120"
  },
  fd2 = {
    name     = "ip_pool_rack2"
    cidr     = "172.16.115.0/24"
    gateway  = "172.16.115.1"
    start_ip = "172.16.115.100"
    end_ip   = "172.16.115.120"
  }
}
# --------------------------------------------------------------- #
# Uplink-Profile for NVDS
# --------------------------------------------------------------- #
uplink_profile = {
  name = "edge_cluster1"
  vlan = 1005
  mtu  = 1700
}
# --------------------------------------------------------------- #
# Edge-Cluster and associated Edge-VMs to be deployed.
#   - Utilize previously named fd# mapping to place accordingly.
# --------------------------------------------------------------- #
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
  },
  edge-vm3 = {
    mgmt_ip      = "172.16.104.102/24"
    mgmt_gw      = "172.16.104.1"
    uplinks      = ["uplink1", "uplink2"]
    fault_domain = "fd1"
    passwords    = {}
  },
  edge-vm4 = {
    mgmt_ip      = "172.16.104.103/24"
    mgmt_gw      = "172.16.104.1"
    uplinks      = ["uplink1", "uplink2"]
    fault_domain = "fd2"
    passwords    = {}
  }
}

edge_cluster_name = "edge_cluster1"
# --------------------------------------------------------------- #
# vCenter Port-Groups
# --------------------------------------------------------------- #
port_groups = {
  mgmt  = ["edge_vm_mgmt", 1004]
  tor_a = "trunk_tor_a"
  tor_b = "trunk_tor_b"
}