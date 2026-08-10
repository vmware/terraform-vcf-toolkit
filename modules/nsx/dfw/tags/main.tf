terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
    }
    vsphere = {
      source = "vmware/vsphere"
    }
  }
}

# --------------------------------------------------------------- #
# vCenter VM ID Lookup
# --------------------------------------------------------------- #
data "vsphere_datacenter" "datacenter" {
  name     = var.datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "vm" {
  for_each      = var.vm_tag_mapping

  name          = each.key
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# --------------------------------------------------------------- #
# VM Tag Association
# --------------------------------------------------------------- #

resource "nsxt_policy_vm_tags" "vcf_mgmt_sddc" {
    for_each = data.vsphere_virtual_machine.vm

    instance_id = each.value.id
    
    dynamic "tag" {
    for_each = var.vm_tag_mapping[each.key].tags

    content {
      tag = tag.value.tag
      scope = tag.value.scope
    }
  }
}