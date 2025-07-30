# --------------------------------------------------------------- #
# Cloudbuilder OVA deployment - Content Library 
# --------------------------------------------------------------- #
terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
    }
  }
}

provider "vsphere" {
  user                 = var.vcenter_username
  password             = var.vcenter_password
  vsphere_server       = var.vcenter_server
  allow_unverified_ssl = true
  api_timeout          = 10
}

module "cloudbuilder" {
  source = "../../../../modules/appliances/cloudbuilder/content_library"

  # vCenter target Cluster for Cloud Builder VM deployment
  datacenter      = var.datacenter
  cluster         = var.cluster
  deployment_host = var.host
  datastore       = var.datastore
  vds             = var.vds
  port_group      = var.port_group
  folder          = var.folder
  resource_pool   = var.resource_pool
  content_library = var.content_library

  # Cloud Builder appliance settings
  cloud_builder_settings  = var.cloud_builder_settings
  cloud_builder_passwords = var.cloud_builder_passwords
}

# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "cloudbuilder" {
  value = [
    module.cloudbuilder,
  ]
}