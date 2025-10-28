# --------------------------------------------------------------- #
# Host Configuration Variables
# --------------------------------------------------------------- #
variable "hosts" {
  description = "Hosts to be commissioned into SDDC Manager."
  type = list(object({
    fqdn         = string
    user         = optional(string, "root")
    password     = string
    storage_type = optional(string, "VSAN")
    network_pool  = string
  }))
}
  
variable "pool" {
  description = "Network pool to be used for host provisioning."
  type        = string
}