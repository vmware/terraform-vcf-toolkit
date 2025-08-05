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
      version = "0.14.0"
    }
  }
}
# --------------------------------------------------------------- #
# VCF Management Domain Creation
# --------------------------------------------------------------- #
resource "vcf_instance" "sddc_instance" {
  instance_id                    = var.sddc_manager.name
  skip_esx_thumbprint_validation = var.validate_thumbprint
  management_pool_name           = "${var.cluster_config.name}_pool"
  ceip_enabled                   = var.ceip

  ntp_servers = var.ntp

  dns {
    domain                = var.domain_suffix
    name_server           = var.dns.0
    secondary_name_server = var.dns.0
  }

  # Network Pool Settings
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
    ip_address = var.sddc_manager.ip
    hostname   = var.sddc_manager.name

    root_user_credentials {
      username = "root"
      password = var.sddc_manager.passwords.root
    }

    second_user_credentials {
      username = "vcf"
      password = var.sddc_manager.passwords.vcf_user
    }
  }

  vcenter {
    vcenter_ip            = var.vcenter.ip
    vcenter_hostname      = var.vcenter.name
    vm_size               = lower(var.vcenter.size)
    root_vcenter_password = sensitive(var.vcenter.root_password)
    license               = var.license_keys.vcenter
  }

  nsx {
    nsx_manager_size          = lower(var.nsx_cluster_settings.size)
    vip                       = var.nsx_cluster_settings.vip
    vip_fqdn                  = var.nsx_cluster_settings.fqdn
    license                   = var.license_keys.nsx
    root_nsx_manager_password = var.nsx_cluster_settings.passwords.root
    nsx_admin_password        = var.nsx_cluster_settings.passwords.admin
    nsx_audit_password        = var.nsx_cluster_settings.passwords.audit

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

    dynamic "nsx_manager" {
      for_each = var.nsx_cluster_appliances
      content {
        hostname = nsx_manager.value.0
        ip       = nsx_manager.value.1
      }
    }

    overlay_transport_zone {
      zone_name    = var.nsx_cluster_settings.transport_zone_name
      network_name = "${var.nsx_cluster_settings.transport_zone_name}_TEP"
    }
    transport_vlan_id = var.nsx_cluster_settings.transport_zone_vlan
  }

  # --------------------------------------------------------------- #
  # Management Cluster Configuration
  # --------------------------------------------------------------- #
  dv_switch_version = var.dvs.version
  esx_license       = var.license_keys.esxi

  psc {
    psc_sso_domain          = var.psc_domain.name
    admin_user_sso_password = sensitive(var.psc_domain.admin_password)
  }

  cluster {
    cluster_name              = var.cluster_config.name
    cluster_image_enabled     = var.cluster_config.vlcm
    host_failures_to_tolerate = var.cluster_config.vsan.ftt

    resource_pool {
      name = "Management Appliances"
      type = "management"
    }
    resource_pool {
      name = "Edges"
      type = "network"
    }
  }

  vsan {
    datastore_name = var.cluster_config.vsan.name
    esa_enabled    = var.cluster_config.vsan.esa
    vsan_dedup     = var.cluster_config.vsan.dedup
    license        = var.license_keys.vsan
  }

  dvs {
    mtu      = var.dvs.mtu
    dvs_name = var.dvs.name

    vmnics = var.dvs.uplinks

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

  # Host Commisioning
  dynamic "host" {
    for_each = var.hosts

    content {
      credentials {
        username = "root"
        password = host.value.3
      }

      ip_address_private {
        ip_address = host.value.0
        subnet     = host.value.1
        gateway    = host.value.2
      }

      hostname    = host.key
      vswitch     = var.standard_switch_name
      association = var.vcenter.datacenter
    }
  }
}

# --------------------------------------------------------------- #
# Outputs
# --------------------------------------------------------------- #
output "vcf_bringup" {
  value = "Bringup Complete! https://${var.sddc_manager.name}/ui"
}