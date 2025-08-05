# --------------------------------------------------------------- #
# Route Map
# [] Defines IP Prefix-Lists and Route-Maps
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
# Read Tier-0 Configuration
# --------------------------------------------------------------- #
data "nsxt_policy_tier0_gateway" "tier0" {
  display_name = var.t0_name
}


#Prefix-List(s) and Route-Map(s)
resource "nsxt_policy_gateway_prefix_list" "prefix_list_out" {
  display_name = "nsx_networks"
  description  = "Advertised routable Segments to the network underlay."
  gateway_path = nsxt_policy_tier0_gateway.tier0.path

  dynamic "prefix" {
    for_each = var.segments_out
    content {
      action  = "PERMIT"
      network = prefix.value
    }
  }
}

resource "nsxt_policy_gateway_prefix_list" "prefix_list_in" {
  display_name = "underlay_networks"
  description  = "Filtered networks from the network underlay."
  gateway_path = nsxt_policy_tier0_gateway.tier0.path

  dynamic "prefix" {
    for_each = var.segments_in
    content {
      action  = "PERMIT"
      network = prefix.value
    }
  }
}

resource "nsxt_policy_gateway_route_map" "route_map_out" {
  display_name = "nsx_fabric_route_map"
  gateway_path = nsxt_policy_tier0_gateway.tier0.path

  entry {
    action              = "PERMIT"
    prefix_list_matches = [nsxt_policy_gateway_prefix_list.prefix_list_out.path]
  }
}