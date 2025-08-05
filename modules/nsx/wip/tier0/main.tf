# --------------------------------------------------------------- #
# Basic Tier-0
# [] Leverages a specified Edge-Cluster
# [] Creates an Active/Active (ECMP) Tier-0 Logical-Router with BGP Routing Protocol
# [] Creates two (2) Uplinks per Edge-VM
# [] Defines BGP configuration with IPv4 addressing
#
# Steven Tumolo - VMW by Broadcom
# Version | 1.0
# --------------------------------------------------------------- #
terraform {
  required_providers {
    nsxt = {
      source  = "vmware/nsxt"
      version = "3.6.0"
    }
  }
}

# --------------------------------------------------------------- #
# Read Transport Zones
# --------------------------------------------------------------- #
data "nsxt_policy_transport_zone" "uplink_tz" {
  display_name = var.uplink_tz
}

data "nsxt_policy_transport_zone" "overlay_tz" {
  display_name = (var.overlay_tz != "nsx-overlay-transportzone" ? var.overlay_tz : "nsx-overlay-transportzone")
}

# --------------------------------------------------------------- #
# Create BGP Uplinks
# --------------------------------------------------------------- #
#Rack1
resource "nsxt_policy_vlan_segment" "fd1_bgp_segments" {
  for_each = var.edge_node_bgp_segments["rack1"]

  display_name        = each.value[0]
  description         = "Rack 1 ${each.value[0]}"
  vlan_ids            = [each.value[1]]
  transport_zone_path = data.nsxt_policy_transport_zone.uplink_tz.path
  advanced_config {
    uplink_teaming_policy = each.value[2]
    urpf_mode             = "NONE"
  }
}

# --------------------------------------------------------------- #
# Read Edge-Cluster and associated Edge-VMs
# --------------------------------------------------------------- #
data "nsxt_policy_edge_cluster" "edge_cluster" {
  display_name = var.edge_cluster_name
}

data "nsxt_policy_edge_node" "edge_nodes_fd1" {
  for_each          = var.edge_vms["rack1"]
  edge_cluster_path = data.nsxt_policy_edge_cluster.edge_cluster.path
  display_name      = each.key
}

# --------------------------------------------------------------- #
# Tier-0 Configuration
# --------------------------------------------------------------- #
resource "nsxt_policy_tier0_gateway" "tier0" {
  display_name         = var.t0_name
  failover_mode        = "NON_PREEMPTIVE"
  default_rule_logging = false
  enable_firewall      = false
  ha_mode              = "ACTIVE_ACTIVE"
  edge_cluster_path    = data.nsxt_policy_edge_cluster.edge_cluster.path

  # BGP
  bgp_config {
    ecmp                  = true
    local_as_num          = var.bgp_asn["local"]
    multipath_relax       = true
    graceful_restart_mode = "DISABLE"
    inter_sr_ibgp         = false
  }
}

resource "nsxt_policy_gateway_redistribution_config" "tier0_redistribution" {
  gateway_path = nsxt_policy_tier0_gateway.tier0.path
  bgp_enabled  = true

  rule {
    name  = "NSX-T to Physical Underlay"
    types = ["TIER0_CONNECTED", "TIER1_CONNECTED"]
  }
}

#Rack1
resource "nsxt_policy_tier0_gateway_interface" "fd1_edge_vm_uplink_if1" {
  for_each       = var.edge_vms["rack1"]
  display_name   = "${each.value[0]}_uplink_tor1"
  description    = "${each.value[0]} uplink to TOR1"
  type           = "EXTERNAL"
  edge_node_path = data.nsxt_policy_edge_node.edge_nodes_fd1[each.key].path
  gateway_path   = nsxt_policy_tier0_gateway.tier0.path
  segment_path   = nsxt_policy_vlan_segment.fd1_bgp_segments["bgp_tor_a"].path
  subnets        = [each.value[1]]
  mtu            = var.edge_node_uplink_mtu
}

resource "nsxt_policy_tier0_gateway_interface" "fd1_edge_vm_uplink_if2" {
  for_each       = var.edge_vms["rack1"]
  display_name   = "${each.value[0]}_uplink_tor2"
  description    = "${each.value[0]} uplink to TOR2"
  type           = "EXTERNAL"
  edge_node_path = data.nsxt_policy_edge_node.edge_nodes_fd1[each.key].path
  gateway_path   = nsxt_policy_tier0_gateway.tier0.path
  segment_path   = nsxt_policy_vlan_segment.fd1_bgp_segments["bgp_tor_b"].path
  subnets        = [each.value[2]]
  mtu            = var.edge_node_uplink_mtu
}


# --------------------------------------------------------------- #
# BGP Configuration
# --------------------------------------------------------------- #
#Rack 1
resource "nsxt_policy_bgp_neighbor" "fd1_bgp_neighbor_tor_a" {
  display_name          = "rack1_neighbor_tor_a"
  description           = "rack1_neighbor_tor_a"
  bgp_path              = nsxt_policy_tier0_gateway.tier0.bgp_config[0].path
  allow_as_in           = true
  graceful_restart_mode = "DISABLE"
  hold_down_time        = var.bgp_timers["timer"]
  keep_alive_time       = var.bgp_timers["keepalive"]
  neighbor_address      = var.edge_node_bgp_config["fd1_bgp_peers"]["tor_a"]
  password              = var.bgp_asn["password"]
  remote_as_num         = var.bgp_asn["remote"]

  bfd_config {
    enabled  = true
    interval = 500
    multiple = 3
  }
}

resource "nsxt_policy_bgp_neighbor" "fd1_bgp_neighbor_tor_b" {
  display_name          = "rack1_neighbor_tor_b"
  description           = "rack1_neighbor_tor_b"
  bgp_path              = nsxt_policy_tier0_gateway.tier0.bgp_config[0].path
  allow_as_in           = true
  graceful_restart_mode = "DISABLE"
  hold_down_time        = var.bgp_timers["timer"]
  keep_alive_time       = var.bgp_timers["keepalive"]
  neighbor_address      = var.edge_node_bgp_config["fd1_bgp_peers"]["tor_b"]
  password              = var.bgp_asn["password"]
  remote_as_num         = var.bgp_asn["remote"]

  bfd_config {
    enabled  = true
    interval = 500
    multiple = 3
  }
}
