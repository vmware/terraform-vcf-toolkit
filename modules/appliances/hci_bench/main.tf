# --------------------------------------------------------------- #
# VCF Cloud Builder Appliance
# [] This module deploys the OVA from a local system
# --------------------------------------------------------------- #
terraform {
  required_providers {
    vsphere = {
      source  = "vmware/vsphere"
      version = "2.6.1"
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

// Deployment Host
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
  name          = format("%s%s", data.vsphere_compute_cluster.cluster.name, "/Resources")
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

// VDS 
data "vsphere_distributed_virtual_switch" "vds" {
  name          = var.vds
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

// Port-Group
data "vsphere_network" "port_group_mgmt" {
  name                            = var.port_group_mgmt
  datacenter_id                   = data.vsphere_datacenter.datacenter.id
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.vds.id
}

data "vsphere_network" "port_group_vm" {
  name                            = var.port_group_vm
  datacenter_id                   = data.vsphere_datacenter.datacenter.id
  distributed_virtual_switch_uuid = data.vsphere_distributed_virtual_switch.vds.id
}
# --------------------------------------------------------------- #
# HCI Bench VM Configuration - From Local 
# --------------------------------------------------------------- #
resource "vsphere_virtual_machine" "hci_bench" {
  name             = var.vm_settings["vm_name"]
  datacenter_id    = data.vsphere_datacenter.datacenter.id
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_resource_pool.resource_pool.id
  host_system_id   = data.vsphere_host.deployment_host.id

  wait_for_guest_ip_timeout  = 5
  wait_for_guest_net_timeout = 5

  num_cpus = 8
  memory   = 8192
  network_interface {
    network_id = data.vsphere_network.port_group_mgmt.id
  }
  network_interface {
    network_id = data.vsphere_network.port_group_vm.id
  }

  ovf_deploy {
    allow_unverified_ssl_cert = true # self-signed
    local_ovf_path            = var.local_ovf_path
    disk_provisioning         = "thin"
    ovf_network_map = {
      "Management Network" = data.vsphere_network.port_group_mgmt.id,
      "VM Network"         = data.vsphere_network.port_group_vm.id
    }
  }

  vapp {
    properties = {
      "Public_Network_Gateway" = var.vm_settings["public_network_gateway"],
      "Public_Network_IP"      = var.vm_settings["public_network_ip"],
      "Public_Network_Size"    = var.vm_settings["public_network_size"],
      "Public_Network_Type"    = var.vm_settings["public_network_type"],
      "IP_Version"             = var.vm_settings["ip_version"],
      "DNS"                    = var.vm_settings["dns"],
      "System_Password"        = var.appliance_password
    }
  }
  /*
  provisioner "remote-exec" {
    inline = [
      # Check for update to appliance
      "tdnf install -y git && git clone https://github.com/vmware-labs/hci-benchmark-appliance.git && sh hci-benchmark-appliance/HCIBench/upgrade.sh"
    ]
    connection {
      type     = "ssh"
      user     = "root"
      password = var.appliance_password
      host     = var.vm_settings["public_network_ip"]
    }
  } */
}