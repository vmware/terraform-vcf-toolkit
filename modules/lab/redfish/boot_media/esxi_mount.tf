terraform {
  required_providers {
    redfish = {
      source = "dell/redfish"
      version = "1.5.0"
    }
  }
}

provider "redfish" {
    user         = "root"
    password     = "calvin!"
    redfish_servers = var.rack1
}

variable "rack1" {
  type = map(object({
    user         = string
    password     = string
    endpoint     = string
    ssl_insecure = bool
  }))
}

resource "redfish_virtual_media" "esxi_iso" {
  for_each = var.rack1

  redfish_server {

    redfish_alias = each.key

    user         = each.value.user
    password     = each.value.password
    endpoint     = each.value.endpoint
    ssl_insecure = true
  }

  image ="http://192.168.1.20/VMware-VMvisor-Installer-8.0U3-24022510.x86_64.iso"
  transfer_method = "Stream"
  transfer_protocol_type = "HTTP"
  write_protected = true
}

resource "redfish_boot_source_override" "boot_settings" {
depends_on = [ redfish_virtual_media.esxi_iso ]
  for_each = var.rack1

  redfish_server {

    redfish_alias = each.key

    user         = each.value.user
    password     = each.value.password
    endpoint     = each.value.endpoint
    ssl_insecure = true
  }
  boot_source_override_enabled = "Once"
  boot_source_override_mode   = "UEFI"
  boot_source_override_target = "UefiTarget"

  reset_type = "ForceRestart"
  reset_timeout = "120"
}