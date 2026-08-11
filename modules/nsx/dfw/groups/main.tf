terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
    }
  }
}
# --------------------------------------------------------------- #
# NSX-T Configuration
# --------------------------------------------------------------- #

//Create Group Objects
resource "nsxt_policy_group" "group" {
  for_each     = var.policy_groups
  display_name = each.key
  description  = each.value.description

  dynamic "criteria" {
    for_each = each.value.expression

    content {
      # Condition Criteria (VirtualMachine, Segment, Tag, etc.)
      dynamic "condition" {
        for_each = lookup(criteria.value, "member_type", null) != "IPAddress" && lookup(criteria.value, "member_type", null) != null ? [criteria.value] : []

        content {
          member_type = condition.value.member_type
          key         = condition.value.key
          operator    = condition.value.operator
          value       = condition.value.value
        }
      }

      # IP Address Expression Criteria (IPs, CIDRs, IP Ranges)
      dynamic "ipaddress_expression" {
        for_each = lookup(criteria.value, "ip_addresses", null) != null || lookup(criteria.value, "member_type", null) == "IPAddress" ? [criteria.value] : []

        content {
          # Accepts a list of IP addresses or splits a comma-separated string
          ip_addresses = lookup(ipaddress_expression.value, "ip_addresses", null) != null ? ipaddress_expression.value.ip_addresses : split(",", ipaddress_expression.value.value)
        }
      }
    }
  }
}