# --------------------------------------------------------------- #
# NSX-T DFW Groups
# --------------------------------------------------------------- #
variable "policy_group_environments" {
  description = "Macro-Segmentation Groups for DFW Policy Rules."
  type        = list(string)
}

# --------------------------------------------------------------- #
# NSX-T DFW Services
# --------------------------------------------------------------- #
variable "enterprise_services" {
  description = "Global Services for re-use."
  type        = map(list(string))
}