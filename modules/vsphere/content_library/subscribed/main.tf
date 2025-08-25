terraform {
  required_providers {
    vsphere = {
      source = "vmware/vsphere"
    }
  }
}

# --------------------------------------------------------------- #
# vCenter Object Discovery
# --------------------------------------------------------------- #
data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# --------------------------------------------------------------- #
# Content Library Configuration
# --------------------------------------------------------------- #
resource "vsphere_content_library" "content_library" {
  name            = var.content_library.name
  description     = var.content_library.description
  storage_backing = [data.vsphere_datastore.datastore.id]

  subscription {
    subscription_url = var.content_library.url
    automatic_sync   = var.content_library.sync
    on_demand        = var.content_library.on_demand
  }
}