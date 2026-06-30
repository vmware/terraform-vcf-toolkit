terraform {
  required_providers {
    nsxt = {
      source = "vmware/nsxt"
    }
  }
}
# --------------------------------------------------------------- #
# DFW Services
# --------------------------------------------------------------- #
resource "nsxt_policy_service" "services" {
  for_each     = var.services
  display_name = "${each.key}"

  l4_port_set_entry {
    protocol          = each.value.protocol
    destination_ports = each.value.port
  }
}