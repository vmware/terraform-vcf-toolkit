terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
    }
  }
}
# --------------------------------------------------------------- #
# DFW Policy
# --------------------------------------------------------------- #
resource "nsxt_policy_security_policy" "policy" {
  depends_on = [nsxt_policy_group.group, nsxt_policy_service.service]

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
      display_name       = rule.key
      source_groups      = [for group in rule.value.src_groups : nsxt_policy_group.group[group].path]
      destination_groups = [for group in rule.value.dst_groups : nsxt_policy_group.group[group].path]
      action             = rule.value.action
      services           = [for service in rule.value.services : nsxt_policy_service.service[service].path]
      logged             = rule.value.log
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}