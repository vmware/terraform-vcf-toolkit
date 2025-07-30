# --------------------------------------------------------------- #
# FILL ME IN
# --------------------------------------------------------------- #
terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
    }
  }
}
# --------------------------------------------------------------- #
# vCenter Settings
# --------------------------------------------------------------- #
provider "vsphere" {
  user                 = "administrator@vsphere.local"
  password             = "Vmware@234##"
  vsphere_server       = "lvn-mgc1-vc1.lvn.broadcom.net"
  allow_unverified_ssl = true # Required for self-signed
}
# --------------------------------------------------------------- #
# Create Categories 
# --------------------------------------------------------------- #
resource "vsphere_tag_category" "category" {
  name             = var.tag_category.name
  description      = var.tag_category.description
  cardinality      = var.tag_category.cardinality
  associable_types = var.tag_category.object_types
}

# --------------------------------------------------------------- #
# Create Tags and associate Categories 
# --------------------------------------------------------------- #
resource "vsphere_tag" "tag" {
  category_id = vsphere_tag_category.category.id
  name        = var.tags.name
  description = var.tags.description
}
# --------------------------------------------------------------- #
# Create Storage Policies
# --------------------------------------------------------------- #
resource "vsphere_vm_storage_policy" "storage_policy" {
  name        = var.storage_policy.name
  description = var.storage_policy.description

  tag_rules {
    tag_category                 = vsphere_tag_category.category.name
    tags                         = [vsphere_tag.tag.name]
    include_datastores_with_tags = true
  }
}
# --------------------------------------------------------------- #
# Tag Datastore with new Tag
# [] Options for extra strep
#   1. Manually right-click the datastore and associate new tag.
#   2. Uncomment out the 'tag_resource' PowerShell PowerCLI command.
#   3. govc tags.attach tanzu datastore-16 (for example)
# --------------------------------------------------------------- #
data "vsphere_datacenter" "datacenter" {
  name = var.storage_policy.datastore.datacenter
}
data "vsphere_datastore" "datastore" {
  name          = var.storage_policy.datastore.name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "terraform_data" "tag_datastore" {
  depends_on = [vsphere_tag_category.category, vsphere_tag.tag]

  provisioner "local-exec" {
    command = sensitive("govc tags.attach ${vsphere_tag.tag.name} ${data.vsphere_datastore.datastore.id}")
    environment = {
      GOVC_URL      = "${var.vcenter_server}"
      GOVC_USERNAME = "${var.vcenter_username}"
      GOVC_PASSWORD = "${var.vcenter_password}"
      GOVC_INSECURE = 1
    }
  }
}

# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "storage_policy" {
  value = vsphere_vm_storage_policy.storage_policy.name
}

output "tags" {
  value = [
    vsphere_tag_category.name,
    vsphere_tag.name
  ]
}