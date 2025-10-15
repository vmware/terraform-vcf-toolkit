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
  version = var.vcf_version
  fips_enabled = var.fips
  ceip_enabled = var.ceip

  instance_id  = var.vcf_instance

  ntp_servers = var.ntp

  dns {
    domain                = var.domain_suffix
    name_server           = var.dns.0
  }

  # Network Pool Settings
  management_pool_name = "${var.cluster_config.name}_pool"

  network {
    network_type   = "VM_MANAGEMENT"
    port_group_key = var.network_pool_mgmt_appliances.port_group_name
    vlan_id        = var.network_pool_mgmt_appliances.vlan
    subnet         = var.network_pool_mgmt_appliances.subnet_cidr
    gateway        = var.network_pool_mgmt_appliances.gateway
    mtu            = var.network_pool_mgmt_appliances.mtu
    active_uplinks = ["uplink1", "uplink2"]
  }

  network {
    network_type   = "MANAGEMENT"
    port_group_key = var.network_pool_mgmt_esxi.port_group_name
    vlan_id        = var.network_pool_mgmt_esxi.vlan
    subnet         = var.network_pool_mgmt_esxi.subnet_cidr
    gateway        = var.network_pool_mgmt_esxi.gateway
    mtu            = var.network_pool_mgmt_esxi.mtu
    active_uplinks = ["uplink1", "uplink2"]
  }

  network {
    network_type   = "VMOTION"
    port_group_key = var.network_pool_mgmt_vmotion.port_group_name
    vlan_id        = var.network_pool_mgmt_vmotion.vlan
    subnet         = var.network_pool_mgmt_vmotion.subnet_cidr
    gateway        = var.network_pool_mgmt_vmotion.gateway
    mtu            = var.network_pool_mgmt_vmotion.mtu
    active_uplinks = ["uplink1", "uplink2"]

    include_ip_address_ranges {
      start_ip_address = var.network_pool_mgmt_vmotion.range_start
      end_ip_address   = var.network_pool_mgmt_vmotion.range_end
    }
  }

  network {
    network_type   = "VSAN"
    port_group_key = var.network_pool_mgmt_vsan.port_group_name
    vlan_id        = var.network_pool_mgmt_vsan.vlan
    subnet         = var.network_pool_mgmt_vsan.subnet_cidr
    gateway        = var.network_pool_mgmt_vsan.gateway
    mtu            = var.network_pool_mgmt_vsan.mtu
    active_uplinks = ["uplink1", "uplink2"]

    include_ip_address_ranges {
      start_ip_address = var.network_pool_mgmt_vsan.range_start
      end_ip_address   = var.network_pool_mgmt_vsan.range_end
    }
  }

  # --------------------------------------------------------------- #
  # Appliances
  # --------------------------------------------------------------- #
  sddc_manager {
    hostname            = var.sddc_manager.hostname
    root_user_password  = var.sddc_manager.passwords.root
    ssh_password        = var.sddc_manager.passwords.ssh
    local_user_password = var.sddc_manager.passwords.local

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
        hostname = nsx_manager.value
      }
    }

    ip_address_pool {
      name                           = "${var.cluster_config.name}_ip_pool"
      description                    = "Management Domain (${var.cluster_config.name}) - Host TEP IP Pool"
      ignore_unavailable_nsx_cluster = true

      subnet {
        cidr    = var.network_pool_mgmt_tep.subnet_cidr
        gateway = var.network_pool_mgmt_tep.gateway

        ip_address_pool_range {
          start = var.network_pool_mgmt_tep.range_start
          end   = var.network_pool_mgmt_tep.range_end
        }
      }
    }

    transport_vlan_id = var.nsx_cluster_settings.transport_zone_vlan
  }

  # --------------------------------------------------------------- #
  # VCF Platforms - Operations, Fleet Manager, Automation
  # --------------------------------------------------------------- #
  dynamic "operations" {
    for_each = var.operations_nodes != null ? [var.operations_nodes] : []
    content {
    dynamic "node" {
        for_each = var.operations_nodes.nodes
        content {
          hostname           = node.value.hostname
          root_user_password = node.value.root_user_password
          type               = node.value.type
        }
      }
      admin_user_password = var.operations_nodes.admin_password
      appliance_size      = var.operations_nodes.appliance_size
      load_balancer_fqdn  = var.operations_nodes.vip_fqdn
    }
  }

  dynamic "operations_collector" {
    for_each = var.operations_collector != null ? [var.operations_collector] : []
    content {
      hostname           = var.operations_collector.hostname
      root_user_password = var.operations_collector.root_user_password
      appliance_size     = var.operations_collector.appliance_size
    }
  }

  dynamic "operations_fleet_management" {
    for_each = var.fleet_manager != null ? [var.fleet_manager] : []
    content {
      hostname            = var.fleet_manager.hostname
      root_user_password  = var.fleet_manager.root_password
      admin_user_password = var.fleet_manager.admin_password
    }
  }

  dynamic "automation" {
    for_each = var.automation_cluster != null ? [var.automation_cluster] : []
    content {
      hostname       = automation.value.hostname
      admin_user_password = automation.value.admin_password
      ip_pool        = automation.value.ip_pool
      node_prefix    = automation.value.node_prefix
      internal_cluster_cidr = automation.value.internal_cluster_cidr
    }
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
    datastore_name       = var.cluster_config.vsan.name
    esa_enabled          = var.cluster_config.vsan.esa
    vsan_dedup           = var.cluster_config.vsan.dedup
    failures_to_tolerate = var.cluster_config.vsan.ftt
  }

  # Networking Configuration
  dvs {
    dvs_name = var.dvs.name
    mtu      = var.dvs.mtu

    dynamic "vmnic_mapping" {
      for_each = var.dvs.uplink_mapping

      content {
        uplink = vmnic_mapping.value.uplink
        vmnic  = vmnic_mapping.value.vmnic
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

    nsxt_switch_config {
      host_switch_operational_mode = var.dvs.nsx_mode
      ip_assignment_type = "STATIC"

      transport_zones {
        name = var.network_pool_mgmt_tep.tz_overlay_name
        transport_type = "OVERLAY"
      }
    }

    nsx_teaming {
      policy = "LOADBALANCE_SRCID"
      active_uplinks = [
        "uplink1",
        "uplink2"
      ]
    }
  }

  # Host Commissioning
  skip_esx_thumbprint_validation = var.validate_thumbprint

  dynamic "host" {
  for_each = var.hosts
    content {
      hostname = host.key

      credentials {
        username = host.value.0
        password = host.value.1
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