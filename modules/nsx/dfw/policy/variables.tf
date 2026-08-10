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
      src_groups = optional(list(string), null)
      dst_groups = optional(list(string), null)
      action     = optional(string, "ALLOW")
      services   = optional(list(string), null)
      log        = optional(bool, false)
      log_label  = optional(string, null)
      scope      = optional(list(string), null)
    }))
  }))
}