# --------------------------------------------------------------- #
# Host Configuration Variables
# --------------------------------------------------------------- #
variable "hosts" {
  description = "Hosts to be commissioned into SDDC Manager."
  type = map(object({
    user         = optional(string, "root")
    password     = string
    storage_type = optional(string, "VSAN")
  }))
}

variable "network_pool" {
  description = "Network Pool name to associate Hosts with."
  type        = string
}