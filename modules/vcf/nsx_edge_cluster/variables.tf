variable "edge_cluster" {
  description = "VCF Edge-Cluster variables."
  type = object({
    name              = string
    form_factor       = optional(string, "MEDIUM") # XLARGE, LARGE, MEDIUM, SMALL
    high_availability = optional(string, "ACTIVE_ACTIVE")
    profile_type      = optional(string, "DEFAULT")
    mtu               = optional(number, 1700)
    routing_type      = optional(string, "EBGP")
    local_asn         = number
    tier0_name        = string
    tier1_name        = optional(string)
    #tier1_type       = optional(string, "ACTIVE_ACTIVE") # or ACTIVE_STANDBY
    skip_tep_routability_check = optional(bool, true)
    passwords = object({
      root  = optional(string, "VMware1!VMware1!")
      admin = optional(string, "VMware1!VMware1!")
      audit = optional(string, "VMware1!VMware1!")
    })
  })
}

variable "edge_nodes" {
  description = "VCF Edge-Node(s) configuration parameters."
  type = map(object({
    fqdn                 = string
    compute_cluster_name = string
    mgmt_ip              = string
    mgmt_gw              = string
    mgmt_pg              = string
    mgmt_vlan            = number
    tep = object({
      gateway            = string
      vlan               = number
      ip1                = string
      ip2                = string
      inter_rack_cluster = optional(bool, false)
    })
    uplinks = list(object({
      vlan       = number
      ip         = string
      peer_ip    = string
      remote_asn = number
      password   = string
    }))
  }))

  validation {
    condition     = length(var.edge_nodes) >= 2 && length(var.edge_nodes) <= 8
    error_message = "Please specify at least two (2) Edge-Nodes and a maximum of eight (8)."
  }
}
