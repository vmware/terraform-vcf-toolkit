terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
    }
  }
}

# --------------------------------------------------------------- #
# Data Sanitization
# --------------------------------------------------------------- #
locals {
  # Collect and flatten all Source and Destination Group names across all Policies and Rules
  all_groups = flatten([
    for policy_key, policy in var.policy : [
      for rule_key, rule in policy.rules : concat(
        rule.src_groups != null ? rule.src_groups : [],
        rule.dst_groups != null ? rule.dst_groups : [],
        rule.scope      != null ? rule.scope      : []
      )
    ]
  ])
  
  # Remove duplicates to create a set of unique group display names
  unique_groups = toset(local.all_groups)

  # Collect and flatten all service names across all Policies and Rules
  all_services = flatten([
    for policy_key, policy in var.policy : [
      for rule_key, rule in policy.rules : (
        rule.services != null ? rule.services : []
      )
    ]
  ])
  
  # Remove duplicates to create a set of unique service display names
  unique_services = toset(local.all_services)
}

# --------------------------------------------------------------- #
# DFW Group(s) - Lookup
# --------------------------------------------------------------- #
data "nsxt_policy_group" "groups" {
  for_each     = local.unique_groups
  display_name = each.value
}

# --------------------------------------------------------------- #
# DFW Service(s) - Lookup
# --------------------------------------------------------------- #
data "nsxt_policy_service" "services" {
  for_each     = local.unique_services
  display_name = each.value
}

# --------------------------------------------------------------- #
# DFW Policy
# --------------------------------------------------------------- #
resource "nsxt_policy_security_policy" "dfw_policy" {
  for_each     = var.policy

  display_name = each.key
  description  = each.value.description
  category     = each.value.category
  stateful     = each.value.stateful
  tcp_strict   = each.value.tcp_strict
  locked       = each.value.locked

  dynamic "rule" {
    for_each = each.value.rules

    content {
      display_name = rule.key
      action       = rule.value.action
      logged       = rule.value.log
      log_label    = rule.value.log_label

      # Map Source Group, Destination Group and Services to display names to resolved NSX object path
      source_groups = rule.value.src_groups != null ? [
        for src in rule.value.src_groups : data.nsxt_policy_group.groups[src].path
      ] : null

      destination_groups = rule.value.dst_groups != null ? [
        for dst in rule.value.dst_groups : data.nsxt_policy_group.groups[dst].path
      ] : null

      services = rule.value.services != null ? [
        for svc in rule.value.services : data.nsxt_policy_service.services[svc].path
      ] : null

      scope = rule.value.scope != null ? [
        for scope in rule.value.scope : data.nsxt_policy_group.groups[scope].path
      ] : null
    }
  }
}