# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
# Edges FD1
output "edges_fd1" {
  value = values(data.nsxt_policy_edge_node.edge_nodes_fd1).*.display_name
}

# Tier-0
output "infra_t0" {
  description = "Infrastructure Tier-0 Gateway"
  value       = nsxt_policy_tier0_gateway.infra_t0.display_name
}