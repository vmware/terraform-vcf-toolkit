variable "policy_groups" {
  description = "Groups for DFW Policy Rules."
  type        = map(object({
    name        = string
    description = optional(string, null)
    expression  = list(object({
      resource_type = string
      key           = string
      operator      = string
      value         = string
    }))
  }))
}