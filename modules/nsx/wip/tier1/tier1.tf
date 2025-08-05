#--------------------------------------------------------------- #
# Tier-1 Configuration
# --------------------------------------------------------------- #
data "nsxt_policy_transport_zone" "overlay_tz" {
  display_name = var.overlay_tz
}
data "nsxt_policy_tier0_gateway" "tier0_gateway" {
  display_name = var.tier0_gateway
}

#Tier-1 Logical-Router(s)
resource "nsxt_policy_tier1_gateway" "tier1_gateways" {
  depends_on = [data.nsxt_policy_tier0_gateway.tier0_gateway]

  for_each                  = var.tier1_gateways
  display_name              = each.value
  description               = "${each.value} tier-1 logical-router"
  tier0_path                = data.nsxt_policy_tier0_gateway.tier0_gateway.path
  route_advertisement_types = ["TIER1_CONNECTED"]
}

#Overlay Segments
resource "nsxt_policy_segment" "segments" {
  depends_on          = [data.nsxt_policy_transport_zone.overlay_tz, nsxt_policy_tier1_gateway.tier1_gateways]
  for_each            = var.segments
  display_name        = "${each.key}_seg"
  description         = "${each.key} workload segment"
  connectivity_path   = nsxt_policy_tier1_gateway.tier_gateways[each.key].path
  transport_zone_path = data.nsxt_policy_transport_zone.overlay_tz.path

  subnet {
    cidr = each.value["gateway_cidr"]
  }
}