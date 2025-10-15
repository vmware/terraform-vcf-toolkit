# --------------------------------------------------------------- #
# Nested lab infrastructure deployment for VMW PSO VCF Engagements
#
# [] Creates administrative groupings (Folders & Resource Pools)
# [] Creates Distributed Port-Group(s) if customized.  Single (default) trunk Port-Group otherwise.
#
# Steven Tumolo - VMW by Broadcom
# Version | 1.1 - 11.26.2024
# --------------------------------------------------------------- #
terraform {
  required_providers {
    vsphere = {
      source = "vmware/vsphere"
    }
  }
}
# --------------------------------------------------------------- #
# vCenter Configuration
# --------------------------------------------------------------- #
// Root Datacenter
data "vsphere_datacenter" "root_datacenter" {
  name = var.root_datacenter
}

// Root Cluster
data "vsphere_compute_cluster" "root_cluster" {
  name          = var.root_cluster
  datacenter_id = data.vsphere_datacenter.root_datacenter.id
}

// Root Datastore
data "vsphere_datastore" "root_datastore" {
  name          = var.root_datastore
  datacenter_id = data.vsphere_datacenter.root_datacenter.id
}

// Resource Pool
resource "vsphere_resource_pool" "root_rp" {
  name                    = var.root_rp
  parent_resource_pool_id = data.vsphere_compute_cluster.root_cluster.resource_pool_id
  depends_on              = [vsphere_folder.root_folder]
}

// Folder
resource "vsphere_folder" "root_folder" {
  path          = var.root_folder
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.root_datacenter.id
}

# --------------------------------------------------------------- #
# Networking Configuration
# --------------------------------------------------------------- #
// Root VDS
data "vsphere_distributed_virtual_switch" "root_vds" {
  name          = var.root_vds
  datacenter_id = data.vsphere_datacenter.root_datacenter.id
}

// Lab Port-Groups
resource "vsphere_distributed_port_group" "port_groups" {
  for_each                        = var.root_pgs
  name                            = each.key
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.root_vds.id

  active_uplinks = ["uplink1", "uplink2"]

  vlan_range {
    min_vlan = each.value.0
    max_vlan = each.value.1
  }

  security_policy_override_allowed = true
  allow_promiscuous                = true
  allow_forged_transmits           = true
  allow_mac_changes                = true
}

# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "folders" {
  value = vsphere_folder.root_folder.path
}

output "port_groups" {
  value = values(vsphere_distributed_port_group.port_groups).*.name
}

output "resource_pool" {
  value = vsphere_resource_pool.root_rp.id
}