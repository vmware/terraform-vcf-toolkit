# --------------------------------------------------------------- #
# VCF Bringup - Management Workload Domain
#
# [] Executes the VCF Bring up
#    - Configures Management Cluster with at least four (4) hosts. 
#    - Deploys vCenter for Management Cluster
#    - Deploys NSX for the Management Cluster
#    - Deploys SDDC Manager
# [] Leverages n (#) pNIC configuration

# Steven Tumolo - VMW by Broadcom
# --------------------------------------------------------------- #
terraform {
  required_providers {
    vcf = {
      source  = "vmware/vcf"
      version = "0.17.1"
    }
  }
}
# --------------------------------------------------------------- #
# VCF Management Domain Creation
# --------------------------------------------------------------- #
resource "vcf_instance" "sddc_instance" {
  instance_id  = var.sddc_manager.hostname
  ceip_enabled = var.ceip

  ntp_servers = var.ntp

  dns {
    domain                = var.domain_suffix
    name_server           = var.dns.0
    secondary_name_server = var.dns.1
  }

  # Network Pool Settings
  management_pool_name = "${var.cluster_config.name}_pool"

  network {
    network_type   = "VM_MANAGEMENT"
    port_group_key = var.network_pool_mgmt_appliances["port_group_name"]
    vlan_id        = var.network_pool_mgmt_appliances["vlan"]
    subnet         = var.network_pool_mgmt_appliances["subnet_cidr"]
    gateway        = var.network_pool_mgmt_appliances["gateway"]
    mtu            = var.network_pool_mgmt_appliances["mtu"]
  }

  network {
    network_type   = "MANAGEMENT"
    port_group_key = var.network_pool_mgmt_esxi["port_group_name"]
    vlan_id        = var.network_pool_mgmt_esxi["vlan"]
    subnet         = var.network_pool_mgmt_esxi["subnet_cidr"]
    gateway        = var.network_pool_mgmt_esxi["gateway"]
    mtu            = var.network_pool_mgmt_esxi["mtu"]
  }

  network {
    network_type   = "VMOTION"
    port_group_key = var.network_pool_mgmt_vmotion["port_group_name"]
    vlan_id        = var.network_pool_mgmt_vmotion["vlan"]
    subnet         = var.network_pool_mgmt_vmotion["subnet_cidr"]
    gateway        = var.network_pool_mgmt_vmotion["gateway"]
    mtu            = var.network_pool_mgmt_vmotion["mtu"]

    include_ip_address_ranges {
      start_ip_address = var.network_pool_mgmt_vmotion["range_start"]
      end_ip_address   = var.network_pool_mgmt_vmotion["range_end"]
    }
  }

  network {
    network_type   = "VSAN"
    port_group_key = var.network_pool_mgmt_vsan["port_group_name"]
    vlan_id        = var.network_pool_mgmt_vsan["vlan"]
    subnet         = var.network_pool_mgmt_vsan["subnet_cidr"]
    gateway        = var.network_pool_mgmt_vsan["gateway"]
    mtu            = var.network_pool_mgmt_vsan["mtu"]

    include_ip_address_ranges {
      start_ip_address = var.network_pool_mgmt_vsan["range_start"]
      end_ip_address   = var.network_pool_mgmt_vsan["range_end"]
    }
  }

  # --------------------------------------------------------------- #
  # Appliances
  # --------------------------------------------------------------- #
  sddc_manager {
    hostname            = var.sddc_manager.hostname
    root_user_password  = var.sddc_manager.passwords.root
    local_user_password = var.sddc_manager.passwords.local
    ssh_password        = var.sddc_manager.passwords.ssh
  }

  vcenter {
    vcenter_hostname      = var.vcenter.hostname
    vm_size               = lower(var.vcenter.size)
    storage_size          = var.vcenter.storage_size
    root_vcenter_password = sensitive(var.vcenter.root_password)
  }

  nsx {
    nsx_manager_size          = lower(var.nsx_cluster_settings.size)
    vip_fqdn                  = var.nsx_cluster_settings.vip_fqdn
    root_nsx_manager_password = var.nsx_cluster_settings.passwords.root
    nsx_admin_password        = var.nsx_cluster_settings.passwords.admin
    nsx_audit_password        = var.nsx_cluster_settings.passwords.audit

    dynamic "nsx_manager" {
      for_each = var.nsx_cluster_appliances
      content {
        hostname = each.value
      }
    }

    ip_address_pool {
      name                           = "${var.cluster_config.name}_ip_pool"
      description                    = "Management Domain (${var.cluster_config.name}) - Host TEP IP Pool"
      ignore_unavailable_nsx_cluster = true

      subnet {
        cidr    = var.network_pool_mgmt_tep["subnet_cidr"]
        gateway = var.network_pool_mgmt_tep["gateway"]

        ip_address_pool_range {
          start = var.network_pool_mgmt_tep["range_start"]
          end   = var.network_pool_mgmt_tep["range_end"]
        }
      }
    }

    transport_vlan_id = var.nsx_cluster_settings.transport_zone_vlan
  }

  # --------------------------------------------------------------- #
  # Management Cluster Configuration
  # --------------------------------------------------------------- #
  cluster {
    cluster_name    = var.cluster_config.name
    datacenter_name = var.cluster_config.datacenter_name

    resource_pool {
      name = "Management Appliances"
      type = "management"
    }
  }

  # Storage Configuration
  vsan {
    datastore_name = var.cluster_config.vsan.name
    esa_enabled    = var.cluster_config.vsan.esa
    vsan_dedup     = var.cluster_config.vsan.dedup
    failures_to_tolerate       = var.cluster_config.vsan.ftt
  }

  # Networking Configuration
  dvs {
    dvs_name = var.dvs.name
    mtu      = var.dvs.mtu

    dynamic "vmnic_mapping" {
      for_each = var.dvs.uplink_mapping

      content {
        uplink = each.value.uplink
        vmnic  = each.value.vmnic
      }
    }

    networks = [
      "MANAGEMENT",
      "VSAN",
      "VMOTION",
      "VM_MANAGEMENT"
    ]

    dynamic "nioc" {
      for_each = var.nioc_profiles

      content {
        traffic_type = nioc.key
        value        = nioc.value
      }
    }
  }

  # Host Commissioning
  skip_esx_thumbprint_validation = var.validate_thumbprint

  dynamic "host" {
    for_each = var.hosts

    content {
      hostname = hosts.value.hostname

      credentials {
        username = hosts.value.username
        password = hosts.value.password
      }
    }
  }
}
# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "vcf_bringup" {
  value = "Bringup Complete! https://${var.sddc_manager.hostname}/ui"
}