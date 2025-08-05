# --------------------------------------------------------------- #
# vSphere Affinity Host Rule Module
# [] Adds any number of VMs into a Host VM Rule to run together.
#
# Steven Tumolo - VMW by Broadcom
# --------------------------------------------------------------- #
data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "vm" {
  for_each      = toset(var.vms)
  name          = each.value
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_compute_cluster_vm_affinity_rule" "rule" {
  name                = var.rule_name
  compute_cluster_id  = data.vsphere_compute_cluster.cluster.id
  virtual_machine_ids = [for k, v in data.vsphere_virtual_machine.vm : v.id]
}

# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "drs_affinity_rule" {
  value = [
    vsphere_compute_cluster_vm_affinity_rule.rule.name,
    join(",", values(data.vsphere_virtual_machine.vm).*.name)
  ]
}