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
      condition {
        member_type = criteria.value.member_type
        key         = criteria.value.key
        operator    = criteria.value.operator
        value       = criteria.value.value
      }
    }
  }
}