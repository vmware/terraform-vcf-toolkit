# --------------------------------------------------------------- #
# NSX-T Fabric Configuration
# --------------------------------------------------------------- #
// Transport Zones & MTU
#VLAN
variable "uplink_tz" {
  description = "VLAN Transport-Zone for Logical-Router uplinks."
  type        = string
}
#Overlay
variable "overlay_tz" {
  description = "Overlay Tranzport-Zone for WLD Segments."
  type        = string
}

# --------------------------------------------------------------- #
# NSX-T Edge-Cluster Configuration
# --------------------------------------------------------------- #
variable "edge_cluster_name" {
  description = "Edge-Cluster name."
  type        = string
}
### TESTING ###
variable "edge_vms" {
  type        = map(map(list(string)))
  description = "Edge-Node configurations variables by Rack/Fault-Domain.  VM Name, MGMT IP, Uplink1 IP, Uplink2 IP."
  /* Example:  
    rack1 = {
      edge# = ["name", "mgmt_ip", "interface1/prefix", "interface2/prefix"]
      #
      edge1 = ["edge-vm-name-1", "10.0.0.11", "172.16.0.5/24", "172.16.1.5/24"] 
      edge3 = ["edge-vm-name-3", "10.0.0.13", "172.16.0.6/24", "172.16.1.6/24"]
      edge5 = ["edge-vm-name-5", "10.0.0.15", "172.16.0.7/24", "172.16.1.7/24"]
      edge7 = ["edge-vm-name-7", "10.0.0.17", "172.16.0.8/24", "172.16.1.8/24"]
    },
    rack2 = {
      edge2 = ["edge-vm-name-2", "10.0.0.12", "172.16.2.5/24", "172.16.3.5/24"]
      edge4 = ["edge-vm-name-4", "10.0.0.14", "172.16.2.6/24", "172.16.3.6/24"]
      edge6 = ["edge-vm-name-6", "10.0.0.16", "172.16.2.7/24", "172.16.3.7/24"]
      edge8 = ["edge-vm-name-8", "10.0.0.18", "172.16.2.8/24", "172.16.3.8/24"]
    }
  */
}
# --------------------------------------------------------------- #
# NSX-T Tier-0 Logical-Router Configuration
# --------------------------------------------------------------- #
// Tier-0 Logical-Router
#Name
variable "t0_name" {
  description = "Tier-0 Logical-Router name."
  type        = string
}

// BGP Config
#ASNs
variable "bgp_asn" {
  description = "BGP local and remote ASNs."
  type        = map(string)
  default = {
    #local  = "65001"
    #remote = "65000"
    #password = "VMware1!"
  }
}

#Timers
variable "bgp_timers" {
  description = "BGP Holddown and keep-alive timers (in sec)."
  type        = map(string)
  #timer     = "12"
  #keepalive = "4"
}

#BGP Segments for Logical-Router Uplinks
variable "edge_node_bgp_segments" {
  description = "NSX-T VLAN Segments for BGP configuration of Logical-Router uplinks."
  type        = map(map(list(string)))

  #bgp_tor_a = [name, VLAN, teaming-policy]
  #bgp_tor_b = [name, VLAN, teaming-policy]
  #
  #bgp_tor_a = ["bgp_tor_a", "1000", "TOR-1"]
  #bgp_tor_b = ["bgp_tor_b", "2000", "TOR-2"]
}

#BGP Peers
variable "edge_node_bgp_config" {
  description = "BGP Peers for each Rack/Fault-Domain"
  type        = map(map(string))
  /* Example
    fd1_bgp_peers = {
      tor_a = "172.16.0.1"
      tor_b = "172.16.1.1"
    }
    fd2_bgp_peers = {
      tor_a = "172.16.2.1"
      tor_b = "172.16.3.1"
  }
 */
}

variable "edge_node_uplink_mtu" {
  type = string
}
# --------------------------------------------------------------- #
# NSX-T Tier-1 Logical-Router Configuration
# Tenant Workload Domain(s)
# --------------------------------------------------------------- #
// Workload Domains, Segments
variable "workload_domain_t1_networks" {
  type = map(list(string))
  default = {
    #wld1_tenant1 = ["Subnet/CIDR", "Gateway/CIDR"]
  }
}

