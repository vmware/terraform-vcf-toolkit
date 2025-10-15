# --------------------------------------------------------------- #
# VyOS Router Deployment Module
# [] Deploys the VyOS OVA for configuration
# [] Creates basic network infrastructure VLANs and interfaces for Lab
#
# Steven Tumolo - VMW by Broadcom
# Version | 1.0
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
// Datacenter
data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

// Cluster
data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

// Host
data "vsphere_host" "deployment_host" {
  name          = var.deployment_host
  datacenter_id = data.vsphere_datacenter.datacenter.id
}


// Datastore
data "vsphere_datastore" "datastore" {
  name          = var.datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

// Resource Pool
data "vsphere_resource_pool" "resource_pool" {
  name          = var.resource_pool != null ? var.resource_pool : var.resource_pool
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

// Folder
data "vsphere_folder" "vm_folder" {
  path = "${var.datacenter}/vm/${var.folder}"
}

// VDS Port-Group - Assumes VDS not NSX Segment for External connectivity
data "vsphere_network" "external_pg" {
  name          = var.external_pg
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

// VDS Port-Group - Assumes VDS not NSX Segment for Internal connectivity
data "vsphere_network" "internal_pg" {
  name          = var.internal_pg
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

# --------------------------------------------------------------- #
# OVF Configuration
# --------------------------------------------------------------- #

resource "vsphere_virtual_machine" "vyos_router" {
  name             = var.vm_settings["vm_name"]
  datastore_id     = data.vsphere_datastore.datastore.id
  datacenter_id    = data.vsphere_datacenter.datacenter.id
  resource_pool_id = data.vsphere_resource_pool.resource_pool.id
  host_system_id   = data.vsphere_host.deployment_host.id
  folder           = var.folder != "vm" ? var.folder : var.folder

  wait_for_guest_net_timeout  = 0
  wait_for_guest_ip_timeout   = 0
  wait_for_guest_net_routable = false

  sync_time_with_host = true
  enable_logging      = true

  cpu_hot_add_enabled    = true
  memory_hot_add_enabled = true

  num_cpus = 2
  memory   = 2048

  network_interface {
    network_id = data.vsphere_network.external_pg.id
  }
  network_interface {
    network_id = data.vsphere_network.internal_pg.id
  }

  ovf_deploy {
    allow_unverified_ssl_cert = true
    local_ovf_path            = var.local_ova_path
    disk_provisioning         = "thin"
    ovf_network_map = {
      "WAN" = data.vsphere_network.external_pg.id
      "LAN" = data.vsphere_network.internal_pg.id
    }
  }

  vapp {
    properties = {
      "password"       = var.password
      "local-hostname" = "${var.vm_settings["vm_name"]}.${var.vm_settings["domain_suffix"]}"
      "ip0"            = var.vm_settings["wan_ip"]
      "netmask0"       = var.vm_settings["mask"]
      "gateway"        = var.vm_settings["gateway"]
      "DNS"            = var.vm_settings["dns"]
      "NTP"            = var.vm_settings["ntp"]
      "user-data"      = filebase64(var.vyos_config)
    }
  }

  lifecycle {
    ignore_changes = [
      annotation,
      vapp[0].properties
    ]
  }
}

# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "vyos_router" {
  value = [
    vsphere_virtual_machine.vyos_router.name,
    vsphere_virtual_machine.vyos_router.vapp[0].properties["ip0"]
  ]
}