# --------------------------------------------------------------- #
# NSX-T Fabric Configuration
# --------------------------------------------------------------- #
variable "transport_zones" {
  description = "Transport-Zones for Segments and VLANs"
  type = object({
    vlan    = optional(string, "nsx-vlan-transportzone")
    overlay = optional(string, "nsx-overlay-transportzone")
  })
}
# --------------------------------------------------------------- #
# Environment Settings
# --------------------------------------------------------------- #
variable "search_domains" {
  description = "List of search domains."
  type        = list(string)
}

variable "dns" {
  description = "List of DNS servers."
  type        = list(string)
}

variable "ntp" {
  description = "List of NTP servers."
  type        = list(string)
}
# --------------------------------------------------------------- #
# NSX-T Edge-Node Settings
# --------------------------------------------------------------- #
variable "ip_pool" {
  description = "Static IP pools for Edge-Node TEP IP assignment. Map name will be fd#."
  type = map(object({
    name     = string
    cidr     = string
    gateway  = string
    start_ip = string
    end_ip   = string
  }))
}

variable "uplink_profile" {
  description = "Uplink Profile for the Edge-Node which will contain criteria for GEVENE tagging, Teaming-Policies, etc."
  type = object({
    name = string
    vlan = number
    mtu  = optional(number, 1700)
  })
}

variable "edge_vms" {
  description = "Edge-Node VM settings."
  type = map(object({
    mgmt_ip = string
    mgmt_gw = string
    passwords = object({
      admin = optional(string, "VMware1!VMware1!")
      audit = optional(string, "VMware1!VMware1!")
      root  = optional(string, "VMware1!VMware1!")
    })
    uplinks      = list(string) #CIDR
    fault_domain = optional(string, "fd1")
    form_factor  = optional(string, "MEDIUM")
  }))

  # --------------------------------------------------------------- # 
  # NSX Edge cluster passwords must meet the following requirements:
  # - At least 12 characters
  # - At least one lower-case letter
  # - At least one upper-case letter
  # - At least one digit
  # - At least one special character (!, @, ^, =, *, +)
  # - At least five different characters
  # - No dictionary words
  # - No palindromes
  # - More than four monotonic character sequence is not allowed
  # --------------------------------------------------------------- # 
}

variable "edge_cluster_name" {
  description = "Display name of the Edge-Cluster"
  type        = string
}
# --------------------------------------------------------------- #
# vCenter Settings
# --------------------------------------------------------------- #
variable "port_groups" {
  description = "VDS/Distributed Port-Groups for Edge-VM connectivity."
  type = object({
    mgmt  = list(string)
    tor_a = optional(string, "trunk_tor_a")
    tor_b = optional(string, "trunk_tor_b")
  })
}

variable "fault_domain" {
  description = "Fault-Domains for Edge-VMs to be deployed into.  These are based on Rack/Cluster locale."
  type = map(object({
    compute_manager = string
    datacenter      = string
    cluster         = string
    datastore       = string
    dvs             = string
    resource_pool   = optional(string, "edge_vms")
    folder          = optional(string, "edge_vms")
  }))
}