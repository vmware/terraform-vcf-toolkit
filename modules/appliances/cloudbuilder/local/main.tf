# --------------------------------------------------------------- #
# vSphere VM Clone
# [] This module deploy the Cloudbuilder VM from a local system.
# --------------------------------------------------------------- #
terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
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

// Folder
data "vsphere_folder" "vm_folder" {
  path = "${var.datacenter}/vm/${var.folder}"
}

// VDS 
data "vsphere_distributed_virtual_switch" "vds" {
  name          = var.vds
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

// Port-Group
data "vsphere_network" "port_group" {
  name                            = var.port_group
  datacenter_id                   = data.vsphere_datacenter.datacenter.id
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.vds.id
}

# --------------------------------------------------------------- #
# Cloud Builder VM Configuration 
# --------------------------------------------------------------- #
resource "vsphere_virtual_machine" "cloud_builder_vm" {
  name             = var.cloud_builder_settings.hostname
  datacenter_id    = data.vsphere_datacenter.datacenter.id
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = var.resource_pool != null ? var.resource_pool : data.vsphere_compute_cluster.cluster.resource_pool_id
  host_system_id   = data.vsphere_host.deployment_host.id
  folder           = data.vsphere_folder.vm_folder.path

  wait_for_guest_ip_timeout  = 0
  wait_for_guest_net_timeout = 0

  num_cpus = 4
  memory   = 4096

  network_interface {
    network_id = data.vsphere_network.port_group.id
  }

  ovf_deploy {
    allow_unverified_ssl_cert = true # self-signed
    local_ovf_path            = var.local_ova_path
    disk_provisioning         = "thin"
    ovf_network_map = {
      "Network 1" = data.vsphere_network.port_group.id
    }
  }

  vapp {
    properties = {
      "guestinfo.hostname"       = var.cloud_builder_settings["hostname"],
      "guestinfo.ip0"            = var.cloud_builder_settings["ip"],
      "guestinfo.netmask0"       = var.cloud_builder_settings["netmask"],
      "guestinfo.gateway"        = var.cloud_builder_settings["gateway"],
      "guestinfo.domain"         = var.cloud_builder_settings["domain"],
      "guestinfo.searchpath"     = var.cloud_builder_settings["searchpath"],
      "guestinfo.ADMIN_USERNAME" = var.cloud_builder_passwords["admin_user"],
      "guestinfo.ADMIN_PASSWORD" = var.cloud_builder_passwords["admin_pass"],
      "guestinfo.ROOT_PASSWORD"  = var.cloud_builder_passwords["root_pass"],
      "guestinfo.DNS"            = var.cloud_builder_settings["dns"],
      "guestinfo.ntp"            = var.cloud_builder_settings["ntp"]
    }
  }
}

# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "cloudbuilder_appliance" {
  value = [
    vsphere_virtual_machine.cloud_builder_vm.name,
    vsphere_virtual_machine.cloud_builder_vm.vapp[0].properties["guestinfo.ip0"]
  ]
}