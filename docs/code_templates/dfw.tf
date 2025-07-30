variable "dfw_policies" {
  description = "DFW Policy Group definition."
  type = map(object({
    name        = string
    description = optional(string, null)
    category    = optional(string, "Application")
    stateful    = optional(bool, true)
    tcp_strict  = optional(bool, false)
    rule = map(object({
      name       = string
      src_groups = list(string)
      dst_groups = list(string)
      action     = string
      services   = optional(list(string), "ANY")
      log        = optional(bool, false)
    }))
  }))
}

###
variable "policy_groups" {
  description = "NSX Policy Group definition."
  type = map(object({
    name        = string
    description = optional(string, null)
    criteria = map(object({
      key         = string
      member_type = string
      operator    = string
      value       = string
    }))
  }))
}