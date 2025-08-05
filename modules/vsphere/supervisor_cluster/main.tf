# --------------------------------------------------------------- #
# Workload Cluster Module for vSphere  
# [] This module deploys the Workload Supervisor Cluster
# - for troublehsooting, check /var/log/vmware/wcp/ on the vCenter server
# --------------------------------------------------------------- #
terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.11.0"
    }
    nsxt = {
      source  = "vmware/nsxt"
      version = "3.8.0"
    }
  }
}

# --------------------------------------------------------------- #
# vCenter Object Discovery
# --------------------------------------------------------------- #
data "vsphere_content_library" "library" {
  name = var.content_library
}

data "vsphere_datacenter" "datacenter" {
  name = var.datacenter
}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = var.cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_storage_policy" "storage_policy" {
  name = var.storage_policy_name
}

data "vsphere_network" "mgmt_net" {
  name          = var.management_network.name
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_distributed_virtual_switch" "dvs" {
  name          = var.dvs
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "nsxt_policy_edge_cluster" "edge_cluster" {
  display_name = var.edge_cluster

}
# --------------------------------------------------------------- #
# Supervisor Cluster Configuration
# --------------------------------------------------------------- #
resource "vsphere_supervisor" "supervisor" {
  cluster         = data.vsphere_compute_cluster.compute_cluster.id
  storage_policy  = data.vsphere_storage_policy.storage_policy.name
  content_library = data.vsphere_content_library.library.id
  main_dns        = [var.dns.environment]
  worker_dns      = [var.dns.worker]
  search_domains  = var.search_domains
  dvs_uuid        = data.vsphere_distributed_virtual_switch.dvs.id
  sizing_hint     = var.k8s_api_size

  edge_cluster = data.nsxt_policy_edge_cluster.edge_cluster.id

  management_network {
    network          = data.vsphere_network.mgmt_net.id
    subnet_mask      = var.management_network.mask
    starting_address = var.management_network.start_ip
    gateway          = var.management_network.gateway
    address_count    = var.management_network.pool_size
  }

  ingress_cidr {
    address = split("/", var.k8s_networks_ext.ingress_net).0
    prefix  = split("/", var.k8s_networks_ext.ingress_net).1
  }

  egress_cidr {
    address = split("/", var.k8s_networks_ext.egress_net).0
    prefix  = split("/", var.k8s_networks_ext.egress_net).1
  }

  service_cidr {
    address = split("/", var.k8s_networks_ext.service_net).0
    prefix  = split("/", var.k8s_networks_ext.service_net).1
  }

  pod_cidr {
    address = split("/", var.pod_net).0
    prefix  = split("/", var.pod_net).1
  }
}

# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "wcp" {
  value = "Workflow complete. Navigate to https://vcenter.fqdn/ui/app/workload-platform/home/services/vc-services"
}