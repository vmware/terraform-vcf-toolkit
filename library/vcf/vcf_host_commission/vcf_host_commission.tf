module "host_commission" {
  source = "../../../modules/vcf/vcf_host_commission"

  # --------------------------------------------------------------- #
  # Module Configuration
  # --------------------------------------------------------------- #

  hosts = var.hosts

}