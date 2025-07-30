module "vcf_cluster" {
  source = "../../../modules/vcf/workload_cluster"

  # --------------------------------------------------------------- #
  # Module Configuration
  # --------------------------------------------------------------- #

  workload_domain_name = var.workload_domain_name
  workload_domain_uuid = var.workload_domain_uuid
  license_keys         = var.license_keys
  #
  vlcm_image_id        = var.vlcm_image_id #optional
  wld_cluster_settings = var.wld_cluster_settings["cluster1"]
  wld_hosts            = var.wld_hosts["cluster1"]
}