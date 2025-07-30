# --------------------------------------------------------------- #
# NSX Distributed Firewall - Macro-Segmentation Policy Example
# [] Creates Groups
# [] Creates Tags
# [] Creates Policies
# [] Creates "Discovery" rules for Inbound - Any/Any and Outbound - Any/Any
#
# Steven Tumolo - VMW by Broadcom
# Version | 1.0
# --------------------------------------------------------------- #
terraform {
  required_providers {
    nsxt = {
      source  = "vmware/nsxt"
      version = "3.8.0"
    }
  }
}
provider "nsxt" {
  # Basic Auth
  host     = "lvn-mgc1-nsx1.lvn.broadcom.net"
  username = "admin"
  password = "Vmware@234##"

  allow_unverified_ssl  = true # Required for self-signed
  max_retries           = 10
  retry_min_delay       = 5000
  retry_max_delay       = 5000
  retry_on_status_codes = [409, 429, 500, 503, 504]
}
# --------------------------------------------------------------- #
# Policy Group(s)
# --------------------------------------------------------------- #
resource "nsxt_policy_group" "group" {
  for_each     = var.policy_groups
  display_name = each.key

  dynamic "criteria" {
    for_each = each.value.criteria
    content {
      condition {
        key         = criteria.value.key
        member_type = criteria.value.member_type
        operator    = criteria.value.operator
        value       = criteria.value.value
      }
    }
  }

  tag {
    scope = var.scope
    tag   = var.tag
  }
}
# --------------------------------------------------------------- #
# Services
# --------------------------------------------------------------- #
resource "nsxt_policy_service" "service" {
  for_each     = var.services
  display_name = each.key

  l4_port_set_entry {
    protocol          = each.value.protocol
    destination_ports = each.value.ports
  }
  tag {
    scope = var.scope
    tag   = var.tag
  }
}

# --------------------------------------------------------------- #
# DFW Policy
# --------------------------------------------------------------- #
resource "nsxt_policy_security_policy" "policy" {
  depends_on = [nsxt_policy_group.group, nsxt_policy_service.service]

  for_each     = var.security_policy
  display_name = each.key
  description  = each.value.description
  category     = each.value.category
  stateful     = each.value.stateful
  tcp_strict   = each.value.tcp_strict
  locked       = each.value.locked


  dynamic "rule" {
    for_each = each.value.rules
    content {
      display_name       = rule.key
      source_groups      = [for group in rule.value.src_groups : nsxt_policy_group.group[group].path]
      destination_groups = [for group in rule.value.dst_groups : nsxt_policy_group.group[group].path]
      action             = rule.value.action
      services           = [for service in rule.value.services : nsxt_policy_service.service[service].path]
      logged             = rule.value.log
    }
  }

  tag {
    scope = var.scope
    tag   = var.tag
  }

  lifecycle {
    create_before_destroy = true
  }
}