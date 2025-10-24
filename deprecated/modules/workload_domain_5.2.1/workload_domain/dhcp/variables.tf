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
# Environment Variables
# --------------------------------------------------------------- #
variable "workload_domain_name" {
  description = "Name of the Workload Domain"
  type        = string
}

variable "domain_suffix" {
  description = "Domain suffix for appliances and hosts."
  type        = string
}

variable "vm_management_network" {
  description = "VM Management network in the Management Domain."
  type = object({
    gateway     = string
    subnet_mask = string
  })
}
# --------------------------------------------------------------- #
# Workload Domain - Appliance Variables
# --------------------------------------------------------------- #
variable "vcenter" {
  description = "vCenter appliance settings for the Management Domain."
  type = object({
    name          = string
    fqdn          = string
    ip            = string
    root_password = string
    size          = optional(string, "medium")   #tiny, small, medium, large, xlarge
    storage       = optional(string, "lstorage") # or xlstorage
    subnet_mask   = optional(string)
    datacenter    = optional(string)
  })
}

variable "nsx_cluster_appliances" {
  description = "NSX appliance cluster names."
  type = object({
    vm1 = list(string)
    vm2 = list(string)
    vm3 = list(string)
  })
}

variable "nsx_cluster_settings" {
  description = "NSX appliance cluster settings for the Management Domain."
  type = object({
    size = optional(string, "medium") # medium or large
    vip  = string
    fqdn = string
    passwords = object({
      admin = string
      audit = string
    })
    transport_zone_name       = string
    transport_zone_port_group = optional(string)
  })
}

# --------------------------------------------------------------- #
# Workload Domain - vSphere Configuration
# [] Cluster can be leveraged for Datacenter, Cluster,
#    VDS and portgroup object names. 
# --------------------------------------------------------------- #
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