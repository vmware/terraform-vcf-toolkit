# --------------------------------------------------------------- #
# Policies
# --------------------------------------------------------------- #
variable "policy" {
  description = "DFW Policy definition."
  type = map(object({
    description = optional(string, null)
    category    = optional(string, "Application")
    stateful    = optional(bool, true)
    tcp_strict  = optional(bool, false)
    locked      = optional(bool, true)
    
    rules = map(object({
      name       = string
      src_groups = list(string)
      dst_groups = list(string)
      action     = optional(string, "ALLOW")
      services   = optional(list(string), null)
      log        = optional(bool, false)
    }))
  }))
}