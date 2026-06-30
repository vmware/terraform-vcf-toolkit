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
  display_name = "${each.value.name}"

  criteria {
    condition {
      key         = "Tag"
      member_type = "VirtualMachine"
      operator    = "EQUALS"
      value       = "tag.${each.value.name}"
    }
  }
}