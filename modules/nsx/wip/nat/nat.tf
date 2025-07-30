# --------------------------------------------------------------- #
# NAT Policy
# [] Leverages a specified Tier-1
# [] Creates NAT rule (SNAT or DNAT)
#
# Steven Tumolo - VMW by Broadcom
# Version | 1.0
# --------------------------------------------------------------- #
terraform {
  required_providers {
    nsxt = {
      source  = "vmware/nsxt"
      version = "3.6.2"
    }
  }
}

# --------------------------------------------------------------- #
# Discover Tier-1 Logical-Router
# --------------------------------------------------------------- #
data "nsxt_policy_tier1_gateway" "tier1_gateway" {
  display_name = var.tier1_gateway
}
# --------------------------------------------------------------- #
# NAT Policy
# --------------------------------------------------------------- #
resource "nsxt_policy_nat_rule" "nat_rules" {
  for_each             = var.nat_rules
  display_name         = each.value["name"]
  action               = each.value["action"]
  source_networks      = each.value["src"]
  destination_networks = each.value["dst"]
  translated_networks  = each.value["translation"]
  gateway_path         = data.nsxt_policy_tier1_gateway.tier1_gateway.path
  logging              = each.value["log"]

  tag {
    scope = (var.scope == "" ? var.scope : null)
    tag   = (var.tag == "" ? var.tag : null)
  }
}