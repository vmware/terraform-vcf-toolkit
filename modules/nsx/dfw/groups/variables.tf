variable "policy_groups" {
  description = "Groups for DFW Policy Rules."
  type        = map(object({
    description = optional(string, null)
    expression  = list(object({
      member_type  = optional(string, null)
      key          = optional(string, null)
      operator     = optional(string, null)
      value        = optional(string, null)
      ip_addresses = optional(list(string), null)
    }))
  }))
}