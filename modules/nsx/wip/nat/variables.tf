variable "tier1_gateway" {
  description = "Display name of the Tier-1 Logical-Router."
  type        = string
}

variable "nat_rules" {
  description = "NAT Policy Rule"
  type = map(object({
    name        = string       # "snat_rule"
    action      = string       # One among "DNAT", "SNAT", "NO_DNAT" or "NO-SNAT"
    src         = list(string) # ["10.0.0.0"]
    dst         = list(string) # ["0.0.0.0"]
    translation = list(string) # ["172.16.0.10"]
    log         = optional(bool, false)
  }))
}

variable "scope" {
  description = "Scope of objects."
  type        = string
  default     = null
}

variable "tag" {
  description = "Tag of objects."
  type        = string
  default     = null
}