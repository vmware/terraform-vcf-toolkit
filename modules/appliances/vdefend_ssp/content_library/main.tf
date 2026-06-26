# --------------------------------------------------------------- #
# vSphere VM Clone
# [] This module clones a VM from Content Library
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

// Content Library
data "vsphere_content_library" "library" {
  name = var.content_library.name
}

data "vsphere_content_library_item" "ova_template" {
  name       = var.content_library.item
  type       = "ovf"
  library_id = data.vsphere_content_library.library.id
}
# --------------------------------------------------------------- #
# Security Services Platform Installer VM Configuration 
# --------------------------------------------------------------- #
resource "vsphere_virtual_machine" "ssp_installer_vm" {
  name             = var.ova_settings["fqdn"]
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_resource_pool.resource_pool.id
  host_system_id   = data.vsphere_host.deployment_host.id
  folder           = data.vsphere_folder.vm_folder.path

  wait_for_guest_ip_timeout  = 0
  wait_for_guest_net_timeout = 0

  num_cpus = 4
  memory   = 4096
  guest_id = "ubuntu64Guest"

  network_interface {
    network_id = data.vsphere_network.port_group.id
  }

  disk {
    label            = "system"
    size             = 400
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_content_library_item.ova_template.id
  }

  vapp {
    properties = {
      "vsx_fqdn"         = var.ova_settings["fqdn"],
      "vsx_ip_0"         = var.ova_settings["ip"],
      "vsx_netmask_0"    = var.ova_settings["netmask"],
      "vsx_gateway_0"    = var.ova_settings["gateway"],
      "vsx_dns1_0"       = var.ova_settings["domain_list"],
      "vsx_ntp_0"        = var.ova_settings["ntp"]
      "vsx_isSSHEnabled" = var.ova_settings["ssh"]
      "vsx_grub_menu_timeout" = var.ova_settings["grub_menu_timeout"]

      # Sensitive Config 
      "vsx_grub_passwd"        = var.ova_passwords["grub_pass"],
      "vsx_cli_passwd_0"       = var.ova_passwords["admin_pass"],
      "vsx_cli_audit_passwd_0" = var.ova_passwords["audit_pass"],
    }
  }
}

# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "ssp_installer_appliance" {
  value = [
    vsphere_virtual_machine.ssp_installer_vm.name,
    vsphere_virtual_machine.ssp_installer_vm.vapp[0].properties["vsx_ip_0"],
  ]
}