# --------------------------------------------------------------- #
# VCF NSX Edge Cluster Module - Basic
#
# [] Deployed via SDDC Manager workflows
# [] Single Rack/Cluster placement (common L2 VLAN)
# [] Supports between two (2) and eight (8) Edge-VMs
# [] One (1) Edge-Cluster
#   - Active/Active (default) or Active/Standby
#   - Tier-0 deployment
#   - Tier-1 (Optional)
#   - No Segments (Day-N workflow)
#
# Steven Tumolo - VMW by Broadcom
# --------------------------------------------------------------- #
terraform {
  required_providers {
    vcf = {
      source  = "vmware/vcf"
      version = "0.14.0"
    }
  }
}
# --------------------------------------------------------------- #
# Edge-Cluster Deployment
# --------------------------------------------------------------- #
resource "vcf_edge_cluster" "edge_cluster" {
  name                       = var.edge_cluster.name
  root_password              = var.edge_cluster.passwords.root
  admin_password             = var.edge_cluster.passwords.admin
  audit_password             = var.edge_cluster.passwords.audit
  tier0_name                 = var.edge_cluster.tier0_name
  tier1_name                 = var.edge_cluster.tier1_name
  tier1_unhosted             = true
  form_factor                = var.edge_cluster.form_factor
  profile_type               = var.edge_cluster.profile_type
  routing_type               = var.edge_cluster.routing_type
  high_availability          = "ACTIVE_ACTIVE"
  mtu                        = var.edge_cluster.mtu
  asn                        = var.edge_cluster.local_asn
  skip_tep_routability_check = true

  dynamic "edge_node" {
    for_each = var.edge_nodes

    content {
      name                 = edge_node.value.fqdn
      compute_cluster_name = edge_node.value.compute_cluster_name

      root_password  = var.edge_cluster.passwords.root
      admin_password = var.edge_cluster.passwords.admin
      audit_password = var.edge_cluster.passwords.audit

      management_ip      = edge_node.value.mgmt_ip
      management_gateway = edge_node.value.mgmt_gw

      management_network {
        portgroup_name = edge_node.value.mgmt_pg
        vlan_id        = edge_node.value.mgmt_vlan
      }

      tep_gateway        = edge_node.value.tep.gateway
      tep1_ip            = edge_node.value.tep.ip1
      tep2_ip            = edge_node.value.tep.ip2
      tep_vlan           = edge_node.value.tep.vlan
      inter_rack_cluster = false

      dynamic "uplink" {
        for_each = edge_node.value.uplinks
        content {
          interface_ip = uplink.value.ip
          vlan         = uplink.value.vlan
          bgp_peer {
            ip       = uplink.value.peer_ip
            asn      = uplink.value.remote_asn
            password = uplink.value.password
          }
        }
      }
    }
  }
}