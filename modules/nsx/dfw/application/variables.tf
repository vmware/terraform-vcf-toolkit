# --------------------------------------------------------------- #
# Global Vars
# --------------------------------------------------------------- #
variable "scope" {
  description = "Parent Scope of Object mapping."
  type        = string
}
variable "tag" {
  description = "Child Scope of Object mapping."
  type        = string
}
# --------------------------------------------------------------- #
# Groups
# --------------------------------------------------------------- #
variable "policy_groups" {
  description = "NSX Policy Group definition."
  type = map(object({
    description = optional(string, null)
    criteria = map(object({
      key         = string
      member_type = string
      operator    = string
      value       = string
    }))
  }))
}
# --------------------------------------------------------------- #
# Policies
# --------------------------------------------------------------- #
variable "security_policy" {
  description = "DFW Policy Group definition."
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
# --------------------------------------------------------------- #
# Services
# --------------------------------------------------------------- #
variable "services" {
  description = "Custom defined services."
  type = map(object({
    description = optional(string)
    protocol    = optional(string, "TCP")
    ports       = list(number)
  }))
}