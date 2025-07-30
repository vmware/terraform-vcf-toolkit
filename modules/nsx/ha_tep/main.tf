# --------------------------------------------------------------- #
# NSX Transport-Node High-Availability Profile
# [] Creates HA-TEP Profile
# [] 
#
# Steven Tumolo - VMW by Broadcom
# Version | 1.0
# --------------------------------------------------------------- #
/* Notes
- Create Sub-Cluster
    - Add hosts / cluster
- Create Sub-TNP
    - vCenter, VDS, Transport-Zones, Uplink-Profile, IP Pool, vNIC Mapping

*/

terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
    }
  }
}
# --------------------------------------------------------------- #
# NSX-T Settings
# --------------------------------------------------------------- #
provider "nsxt" {
  host                  = "https://${var.nsx_manager}"
  username              = var.nsx_username
  password              = var.nsx_password
  allow_unverified_ssl  = true # Required for self-signed
  max_retries           = 10
  retry_min_delay       = 5000
  retry_max_delay       = 5000
  retry_on_status_codes = [429]
}
# --------------------------------------------------------------- #
# NSX-T Discover
# --------------------------------------------------------------- #
data "nsxt_policy_transport_zone" "overlay_tz" {
  display_name = var.tz_overlay
}
data "nsxt_policy_uplink_host_switch_profile" "uplink_profile" {
  display_name = var.uplink_profile
}

data "nsxt_policy_ip_pool" "ip_pool" {
  display_name = var.ip_pool
}

# --------------------------------------------------------------- #
# HA-TEP Profile Config
# --------------------------------------------------------------- #
resource "nsxt_policy_vtep_ha_host_switch_profile" "vtep_ha_host_switch_profile" {
  description  = var.ha_tep_profile.description
  display_name = var.ha_tep_profile.name

  auto_recovery              = var.ha_tep_profile.auto_recovery
  auto_recovery_initial_wait = var.ha_tep_profile.wait
  auto_recovery_max_backoff  = var.ha_tep_profile.backoff
  enabled                    = var.ha_tep_profile.enabled
  failover_timeout           = var.ha_tep_profile.failover_timeout
}

# --------------------------------------------------------------- #
# New Transport-Node Profile
# --------------------------------------------------------------- #
resource "nsxt_policy_host_transport_node_profile" "ha_tnp" {
  display_name = "host_transport_node_profile1"

  standard_host_switch {
    host_switch_mode = var.host_tnp.switch_mode
    host_switch_id   = var.host_switch_uuid #https://api/v1/fabric/virtual-switches

    host_switch_profile = [
      data.nsxt_policy_uplink_host_switch_profile.uplink_profile.path,
      nsxt_policy_vtep_ha_host_switch_profile.vtep_ha_host_switch_profile.path
    ]

    is_migrate_pnics = false

    ip_assignment {
      assigned_by_dhcp = false

      static_ip_pool = data.nsxt_policy_ip_pool.ip_pool.path
    }
    transport_zone_endpoint {
      transport_zone = data.nsxt_policy_transport_zone.overlay_tz.path
    }
    dynamic "uplink" {
      for_each = var.host_tnp.uplink_mapping

      content {
        vds_uplink_name = uplink.key
        uplink_name     = uplink.value
      }
    }
  }
}
