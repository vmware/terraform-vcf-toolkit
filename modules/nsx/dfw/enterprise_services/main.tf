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
resource "nsxt_policy_group" "environment_groups" {
  for_each     = toset(var.policy_group_environments)
  display_name = "${each.key}_vm_all"

  criteria {
    condition {
      key         = "Tag"
      member_type = "VirtualMachine"
      operator    = "EQUALS"
      value       = "tag.${each.key}"
    }
  }
}

// Infrastructure Category Rules 
resource "nsxt_policy_security_policy" "rule_global_enterprise_services" {
  display_name = "Enterprise Services"
  description  = "Access to enterprise services."
  category     = "Infrastructure"
  locked       = false
  stateful     = true
  tcp_strict   = false

  dynamic "rule" {
    for_each = var.enterprise_services
    content {

      display_name       = "global.enterprise_services.${rule.key}"
      destination_groups = []
      action             = "ALLOW"
      services           = [nsxt_policy_service.enterprise_services[rule.key].path]
      logged             = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Environment Category Rules 
resource "nsxt_policy_security_policy" "policy_environments" {
  for_each = toset(var.policy_group_environments)

  display_name = "env.${each.key}"
  description  = "${each.key} to ${each.key} VM communications"
  category     = "Environment"
  locked       = false
  stateful     = true
  tcp_strict   = false

  rule {
    display_name = "allow_inter_${each.key}_communications"
    #display_name       = "allow_${each.key}_rule"
    source_groups      = [nsxt_policy_group.environment_groups["${each.key}"].path]
    destination_groups = [nsxt_policy_group.environment_groups["${each.key}"].path]
    action             = "ALLOW"
    services           = []
    logged             = true
    scope              = [nsxt_policy_group.environment_groups["${each.key}"].path]
  }

  tag {
    scope = "environment"
    tag   = each.key
  }

  lifecycle {
    create_before_destroy = true
  }
}

//Services
resource "nsxt_policy_service" "enterprise_services" {
  for_each     = var.enterprise_services
  display_name = "prod.svc.${each.key}"

  l4_port_set_entry {
    protocol          = each.value[0]
    destination_ports = [each.value[1]]
  }
  tag {
    scope = "dfw"
    tag   = "enterprise services"
  }
}
