# --------------------------------------------------------------- #
# SDDC Workload Domain Deployment Module
# [] Assumes 'Host Commissioning' is completed
# [] Assumes pre-existing Network Pool for vSAN and vMotion
# [] Creates Workload Domain, vCenter and NSX instance, Datacenter and Cluster
# [] Configures hosts into newly defined cluster and prepares with NSX VIBs
#
# Steven Tumolo - VMW by Broadcom
# --------------------------------------------------------------- #
terraform {
  required_providers {
    vcf = {
      source  = "vmware/vcf"
      version = "0.17.1"
    }
    vsphere = {
      source  = "vmware/vsphere"
    }
  }
}
# --------------------------------------------------------------- #
# Lookup Host UUIDs from Host Commissioning Module
# --------------------------------------------------------------- #
/*
data "vcf_host" "wld_hosts" {
  for_each = toset(var.wld_hosts.fqdn)
  fqdn = each.value
}
*/
# --------------------------------------------------------------- #
# Define Cluster Personality - Leveraging the VCF Management Domain
# --------------------------------------------------------------- #
data "vcf_domain" "management_domain" {
  name = var.management_domain
}

data "vsphere_datacenter" "image_source_dc" {
  name = var.source_cluster_image.datacenter
}

data "vsphere_compute_cluster" "image_source_cluster" {
  name          = var.source_cluster_image.name
  datacenter_id = data.vsphere_datacenter.image_source_dc.id
}

# --------------------------------------------------------------- #
# Create Workload Domain image from Management Domain cluster
# --------------------------------------------------------------- #
/*
resource "vcf_cluster_personality" "wld01" {
    name      = "wld01-personality"
    cluster_id = data.vsphere_compute_cluster.image_source_cluster.id
    domain_id = data.vcf_domain.management_domain.id
}*/  
# --------------------------------------------------------------- #
# VCF Configuration - Workload Domain
# --------------------------------------------------------------- #
resource "vcf_domain" "workload_domain" {

  name = var.workload_domain_name

  # SSO
  sso {
    domain_name = var.sso_domain_name
    domain_password = sensitive(var.sso_domain_password)
  }

  # vCenter Settings
  vcenter_configuration {
    name            = var.vcenter.name
    fqdn            = var.vcenter.fqdn
    vm_size         = var.vcenter.size
    storage_size    = var.vcenter.storage
    ip_address      = var.vcenter.ip
    subnet_mask     = var.vm_management_network.subnet_mask
    gateway         = var.vm_management_network.gateway
    datacenter_name = var.vcenter.datacenter
    root_password   = sensitive(var.vcenter.root_password) 
  }

  # NSX Settings
  nsx_configuration {
    form_factor                = var.nsx_cluster_settings.size
    vip                        = var.nsx_cluster_settings.vip
    vip_fqdn                   = var.nsx_cluster_settings.fqdn
    nsx_manager_admin_password = sensitive(var.nsx_cluster_settings.passwords.admin)
    nsx_manager_audit_password = sensitive(var.nsx_cluster_settings.passwords.audit)

    dynamic "nsx_manager_node" {
      for_each = var.nsx_cluster_appliances
      content {
        name        = nsx_manager_node.value.0
        fqdn        = "${nsx_manager_node.value.0}.${var.domain_suffix}"
        ip_address  = nsx_manager_node.value.1
        subnet_mask = var.vm_management_network.subnet_mask
        gateway     = var.vm_management_network.gateway
      }
    }
  }

  cluster {
    name                      = var.cluster_config.name
    high_availability_enabled = var.cluster_config.ha
    geneve_vlan_id            = var.ip_pool_host_tep.vlan
    cluster_image_id = var.personality_id 

    vds {
      name           = "${var.cluster_config.name}-vds"
      is_used_by_nsx = true

      portgroup {
        name           = "${var.cluster_config.name}-mgmt"
        transport_type = "MANAGEMENT"
        active_uplinks = var.dvs.uplinks
      }
      portgroup {
        name           = "${var.cluster_config.name}-vmotion"
        transport_type = "VMOTION"
        active_uplinks = var.dvs.uplinks
      }
      portgroup {
        name           = "${var.cluster_config.name}-vsan"
        transport_type = "VSAN"
        active_uplinks = var.dvs.uplinks
      }
    }

    vsan_datastore {
      datastore_name       = var.cluster_config.vsan.name == null ? var.cluster_config.vsan.name : "${var.cluster_config.name}-vsan"
      #failures_to_tolerate = var.cluster_config.vsan.ftt
      esa_enabled = var.cluster_config.vsan.esa
    }

    ip_address_pool {
      name                           = "${var.cluster_config.name}_ip_pool"
      description                    = "${var.cluster_config.name} static Host TEP IP_POOL"
      ignore_unavailable_nsx_cluster = true

      subnet {
        cidr    = var.ip_pool_host_tep.subnet_cidr
        gateway = var.ip_pool_host_tep.gateway

        ip_address_pool_range {
          start = var.ip_pool_host_tep.range_start
          end   = var.ip_pool_host_tep.range_end
        }
      }
    }

    dynamic "host" {
      for_each = var.wld_hosts.uuids

      content {
        id          = host.value

        dynamic "vmnic" {
          for_each = var.dvs.uplinks

          content {
            id       = vmnic.value
            vds_name = var.dvs.name == null ? var.dvs.name : "${var.cluster_config.name}-vds"
          }
        }
      }
    }
  }
}
