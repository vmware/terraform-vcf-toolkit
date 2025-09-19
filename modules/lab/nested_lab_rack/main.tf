# --------------------------------------------------------------- #
# Nested ESXi host deployment for a VCF Nested Lab
# [] Deploys # of ESXi VMs
#
# Steven Tumolo - VMW by Broadcom
# Version | 2.0
# --------------------------------------------------------------- #
terraform {
  required_providers {
    vsphere = {
      source  = "vmware/vsphere"
      version = "2.15.0"
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
data "vsphere_resource_pool" "root_rp" {
  name          = var.root_rp
  datacenter_id = data.vsphere_datacenter.root_datacenter.id
}

// Folder
data "vsphere_folder" "root_folder" {
  path = "${var.root_datacenter}/vm/${var.root_folder}"
}

// Root Port-Group(s)
data "vsphere_network" "nested_lab_pg" {
  name          = var.nested_lab_pg
  datacenter_id = data.vsphere_datacenter.root_datacenter.id
}

// Root VM Template
data "vsphere_virtual_machine" "root_template" {
  name          = var.esxi_template
  datacenter_id = data.vsphere_datacenter.root_datacenter.id
}
# --------------------------------------------------------------- #
# Nested ESXi VM Configuration
# --------------------------------------------------------------- #
resource "vsphere_virtual_machine" "nested_esxi" {
  depends_on = [data.vsphere_network.nested_lab_pg, data.vsphere_folder.root_folder, data.vsphere_resource_pool.root_rp]

  for_each         = var.nested_hosts
  name             = each.key
  datastore_id     = data.vsphere_datastore.root_datastore.id
  resource_pool_id = data.vsphere_resource_pool.root_rp.id
  folder           = data.vsphere_folder.root_folder.path

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  sync_time_with_host = true
  enable_logging      = true
  nested_hv_enabled   = true

  firmware = "efi"

  # Compute Configuration
  #guest_id             = "vmkernel65Guest"
  guest_id             = "vmkernel8Guest" #required for 9.0
  num_cpus             = var.host_cpus  #16
  num_cores_per_socket = var.host_cores #8
  memory               = var.host_mem   #131076
  memory_hot_add_enabled = true

  # Network Configuration
  dynamic "network_interface" {
    for_each = var.host_uplinks

    content {
      network_id = data.vsphere_network.nested_lab_pg.id
    }
  }

  # Datastore Configuration
  nvme_controller_count = 3

  disk {
    label            = "os"
    size             = 32
    thin_provisioned = true
    unit_number      = 0
    controller_type = "nvme"
  }
  disk {
    label            = "cache"
    size             = 64
    thin_provisioned = true
    unit_number      = 1
    controller_type = "nvme"
  }
  disk {
    label            = "data1"
    size             = var.data_disk_size
    thin_provisioned = true
    unit_number      = 2
    controller_type = "nvme"
  }


  # OVF Template (deployed to destination vCenter)
  clone {
    template_uuid = data.vsphere_virtual_machine.root_template.id
  }

  # OVF Template / vApp Properties
  vapp {
    properties = {
      "guestinfo.hostname"  = each.key,
      "guestinfo.ipaddress" = each.value,
      "guestinfo.netmask"   = var.management_network_info["subnetmask"],
      "guestinfo.gateway"   = var.management_network_info["gateway"],
      "guestinfo.vlan"      = var.management_network_info["vlan"],
      "guestinfo.dns"       = var.dns,
      "guestinfo.domain"    = var.search_domain,
      "guestinfo.ntp"       = var.ntp,
      "guestinfo.password"  = "${var.passwords["root"]}",
      "guestinfo.ssh"       = "True",
      "guestinfo.followmac" = "True"
    }
  }

  lifecycle {
    ignore_changes = [
      vapp[0]
    ]
  }
}
# --------------------------------------------------------------- #
# Ouputs
# --------------------------------------------------------------- #
output "hosts" {
  value = values(vsphere_virtual_machine.nested_esxi).*.name
}