
# --------------------------------------------------------------- #
# Edge-VM vSphere Infrastructure
# --------------------------------------------------------------- #
variable "pg_edge_mgmt" {
  description = "vSphere Distributed Port-Group mapping, Single VLAN ID."
  type = map(object({
    vlan = optional(number, 0) # VLAN ID 
    uplinks = object({
      active  = list(string) # ["uplink1", "uplink2"]
      standby = optional(list(string), null)
    })
  }))
}

variable "pg_trunk" {
  description = "vSphere Distributed Port-Group mapping."
  type = map(object({
    start = optional(number, 0)
    end   = optional(number, 4094)
    uplinks = object({
      active  = list(string)                 # ["uplink1"]
      standby = optional(list(string), null) # ["uplink2"]
    })
  }))
}
# --------------------------------------------------------------- #
# vCenter Configuration Discovery Data
# --------------------------------------------------------------- #
variable "compute_manager" {
  description = "vCenter / NSX Compute Manager"
  type        = string
}

variable "datacenter" {
  description = "List of vSphere Datacenter Edge-VMs will be deployed to."
  type        = string
}

variable "vsphere_clusters" {
  description = "Map of vSphere Clusters Edge-VMs will be deployed to."
  type = map(object({
    datastore = string # name of the datastore / storage backing
  }))
}

variable "vsphere_dvs" {
  description = "List of vSphere Distributed Switches."
  type        = list(string)
}
# --------------------------------------------------------------- #
# NSX Configuration Discovery Data
# --------------------------------------------------------------- #
variable "transport_zones" {
  description = "NSX Transport-Zones to be added to the Edge-VM."
  type = object({
    overlay = optional(string, "nsx-overlay-transportzone") # unless specified, will take the NSX default Overlay Transport-Zone.
    vlan    = string
  })
}
# --------------------------------------------------------------- #
# Edge-VM Configuration Parameters
# --------------------------------------------------------------- #
variable "edge_vms" {
  description = "Edge-VM variables to place VMs on a single vSphere Cluster or multiple vSphere Clusters."
  type = map(object({
    vc            = string       # Compute Manager (vCenter)
    cluster       = string       # vSphere Cluster to deploy the VM
    mgmt_net      = string       # Port-Group name for vNIC 0/Management
    data_net      = list(string) # Fast-Path data interfaces (vNIC 1-3) FP0, FP1, FP2, FP3
    dns           = string
    ntp           = string
    search_domain = string
    size          = optional(string, "MEDIUM")                # One of "SMALL", "MEDIUM", "LARGE", "XLARGE"
    passwords     = optional(map(string), "VMware1!VMware1!") # admin, root
    ssh           = optional(bool, true)
    root_login    = optional(bool, true)
    scope         = optional(string, null)
    tag           = optional(string, null)
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

  validation {
    condition     = can(regex("^[a-zA-Z0-9- ]+$", var.edge_vms))
    error_message = "Edge-VM name must not contain underscores and/or spaces."
  }
  validation {
    condition     = length(var.edge_vms["passwords"]) >= 12
    error_message = "Password must be at least 15 characters."
  }
  validation {
    condition     = can(regex("^(?=.*[A-Z])$", var.edge_vms["password"]))
    error_message = "Password must contain at least 1 uppercase letter."
  }
  validation {
    condition     = can(regex("^(?=.*[a-z])$", var.edge_vms["password"]))
    error_message = "Password must contain at least 1 lowercase letter."
  }
  validation {
    condition     = can(regex("^(?=.*\\d)$", var.edge_vms["password"]))
    error_message = "Password must contain at least 1 digit"
  }
  validation {
    condition     = can(regex("^(?=.*[!@^=*+])$", var.edge_vms["password"]))
    error_message = "Password must contain at least 1 special character (!, @, ^, =, *, +)."
  }
}