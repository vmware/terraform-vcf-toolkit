# --------------------------------------------------------------- #
# NSX-T Tier-1 Logical-Router Configuration
# --------------------------------------------------------------- #

// Tier-0 Gateway
variable "tier0_gateway" {
  description = "Tier-0 Logical-Router to attach Tier-1 Logical-Router."
  type        = string
}

// Tier-1 Gateway(s)
variable "tier1_gateways" {
  description = "Tier-1 Logical-Router(s) to create."
  type        = list(string)
}

// Segment Configuration
variable "overlay_tz" {
  description = "Overlay Transport-Zone where Segments will be added."
  type        = string
}

variable "segments" {
  description = "Segments and associated Tier-1 to attach. Each 'map' name should align to the name of the Tier-1."
  type        = map(map(string))
  default = {
    tenant_1 = {
      subnet_cidr  = ""
      gateway_cidr = ""
    },
  }
}