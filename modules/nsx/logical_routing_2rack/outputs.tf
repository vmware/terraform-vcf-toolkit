# --------------------------------------------------------------- #
# Outputs for 04_logical_routing
# --------------------------------------------------------------- #
# Edges FD1
output "edges_fd1" {
  value = values(data.nsxt_policy_edge_node.edge_nodes_fd1).*.display_name
}
# Edges FD2
output "edges_fd2" {
  value = values(data.nsxt_policy_edge_node.edge_nodes_fd2).*.display_name
}
# Tier-0
output "infra_t0" {
  description = "Infrastructure Tier-0 Gateway"
  value       = nsxt_policy_tier0_gateway.infra_t0.display_name
}
# Tier-1
output "tier_1s" {
  description = "Tenant WLD Tier-1 Gateways"
  value       = values(nsxt_policy_tier1_gateway.wld_t1_gateways).*.display_name
}
# Segments
output "segments" {
  description = "Tenant WLD Segments"
  value       = values(nsxt_policy_segment.wld_segments).*.display_name
}