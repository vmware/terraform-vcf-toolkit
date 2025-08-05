# --------------------------------------------------------------- #
# Licensing 
# --------------------------------------------------------------- #
variable "license_keys" {
  description = "License Keys for the Workload Domain"
  type        = map(string)
  default = {
    #nsx = "AAAAA-BBBBB-CCCCC-DDDDD-EEEEE"
    #vcenter = "AAAAA-BBBBB-CCCCC-DDDDD-EEEEE"
    #vsan = "AAAAA-BBBBB-CCCCC-DDDDD-EEEEE"
    #esxi = "AAAAA-BBBBB-CCCCC-DDDDD-EEEEE"
  }
  sensitive = true
}

# --------------------------------------------------------------- #
# Workload Domain Variables
# --------------------------------------------------------------- #
variable "workload_domain_name" {
  description = "Name of the Workload Domain"
  type        = string
}

# --------------------------------------------------------------- #
# Workload Domain - vSphere Configuration
# [] Cluster name is leveraged for Datacenter, Cluster,
#    VDS and portgroup object names. 
# --------------------------------------------------------------- #
variable "vlcm_image_id" {
  description = "vLCM Image for cluster creation."
  type        = string
  default     = null
}

variable "cluster_config" {
  description = "vSphere Cluster configuration."
  type = object({
    name = string
    vsan = object({
      name  = optional(string, null)
      esa   = optional(bool, false)
      ftt   = optional(number, 1)
      dedup = optional(bool, false)
    })
    vlcm = optional(bool, true)
    ha   = optional(bool, true)
  })
}

variable "dvs" {
  description = "Distributed Virtual Switch settings for the Workload Cluster."
  type = object({
    name    = optional(string, null)
    version = optional(string, "8.0")
    mtu     = optional(string, 1700)
    uplinks = list(string)
  })

  validation {
    condition     = length(var.dvs.uplinks) >= 2 && length(var.dvs.uplinks) <= 16
    error_message = "Number of uplinks supported is between two (2) and sixteen (16)"
  }
}

variable "ip_pool_host_tep" {
  description = "Network pool for NSX Tunnel-Endpoints."
  type = object({
    subnet_cidr = string
    gateway     = string
    vlan        = number
    mtu         = number
    range_start = string
    range_end   = string
  })
}

variable "wld_hosts" {
  type = map(object({
    uuid         = string
    host_uplinks = optional(list(string), ["vmnic0", "vmnic1"])
  }))

  validation {
    condition     = length(values(var.wld_hosts).*.host_uplinks) >= 2 && length(values(var.wld_hosts).*.host_uplinks) <= 16
    error_message = "Number of uplinks supported is between two (2) and sixteen (16)"
  }
}