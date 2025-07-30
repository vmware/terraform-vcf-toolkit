# --------------------------------------------------------------- #
# VCF based NSX Edge-Cluster deployment
# --------------------------------------------------------------- #
module "wld_edge_cluster" {
  source = "../../../../modules/vcf/nsx_edge_cluster"

  edge_cluster = var.edge_cluster
  edge_nodes   = var.edge_nodes
}

# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "wld_edge_clsuter" {
  value = module.mgmt_edge_cluster
}