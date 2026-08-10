variable "policy_groups" {
  description = "Groups for DFW Policy Rules."
  type        = map(object({
    description = optional(string, null)
    expression  = list(object({
      member_type  = string
      key           = string
      operator      = string
      value         = string
    }))
  }))
}