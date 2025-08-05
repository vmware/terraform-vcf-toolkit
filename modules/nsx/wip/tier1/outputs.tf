# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #

# Tier-1
output "tier1_gateways" {
  description = "Tenant WLD Tier-1 Gateways"
  value       = values(nsxt_policy_tier1_gateway.tier1_gateways).*.display_name
}
# Segments
output "segments" {
  description = "Tenant WLD Segments"
  value       = values(nsxt_policy_segment.segments).*.display_name
}