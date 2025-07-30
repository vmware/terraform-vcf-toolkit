# --------------------------------------------------------------- #
# NSX Project
# [] Creates a Project for isolated configuration space of Networking and Security objects
# [] Requires a pre-deployed Edge-Cluster, must be configured in default Transport-Zone
# [] Requires a pre-deployed Tier-0
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
# NSX-T Configuration - Read Object(s)
# --------------------------------------------------------------- #
data "nsxt_policy_tier0_gateway" "t0" {
  display_name = var.tier0_name
}
data "nsxt_policy_edge_cluster" "project_edge_cluster" {
  display_name = var.edge_cluster_name
}
# --------------------------------------------------------------- #
# NSX-T Configuration - Project
# --------------------------------------------------------------- #
resource "nsxt_policy_project" "project" {
  depends_on          = [data.nsxt_policy_edge_cluster.project_edge_cluster, data.nsxt_policy_tier0_gateway.t0]
  display_name        = var.project_name
  description         = var.project_name
  tier0_gateway_paths = [data.nsxt_policy_tier0_gateway.t0.path]
  site_info {
    edge_cluster_paths = [data.nsxt_policy_edge_cluster.project_edge_cluster.path]
  }
}