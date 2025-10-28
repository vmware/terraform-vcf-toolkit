# --------------------------------------------------------------- #
# Root vCenter Configuration
# [] All attributes will come from the vCenter these nested hosts
#    will be deployed to.  This is considered the "Root".
# --------------------------------------------------------------- #
// Datacenter
variable "root_datacenter" {
  description = "Root Datacenter"
  type        = string
}
// Cluster Name
variable "root_cluster" {
  description = "Root vSphere Cluster (top level esxi cluster)"
  type        = string
}
// Datastore
variable "root_datastore" {
  description = "Root Datastore (top level esxi cluster)"
  type        = string
}
// Virtual Distributed Switch
variable "root_vds" {
  description = "Root Virtual Distributed Switch (top level esxi cluster)"
  type        = string
}
// Root Port-Groups
variable "root_pgs" {
  description = "Root Port-Groups for Nested Hosts/VMs"
  type        = map(list(string))
  default = {
    #trunk_a = ["iaas_nested_lab_trunk_tor_a", 0-4094]
    #trunk_b = ["iaas_nested_lab_trunk_tor_b", 0-4094]
  }
}
// Root Host
variable "root_host" {
  description = "Root Host for Nested VMs"
  type        = string
}

// Resource Pool
variable "root_rp" {
  description = "vCenter Resource Pool for Nested Lab VMs"
  type        = string
}
// Folder Pool
variable "root_folder" {
  description = "vCenter Folder for Nested Lab VMs"
  type        = string
}

# --------------------------------------------------------------- #
# Nested Environment Configuration
# --------------------------------------------------------------- #

// ESXi Template
variable "esxi_template" {
  description = "ESXI Template for nested lab deployment."
  type        = string
}

// Hosts
variable "nested_hosts" {
  description = "Nested ESXi Hosts, these are also VM names"
  type        = map(string)
  default = {
    #host-1 = "ip", 
  }
}
// Port-Group
variable "nested_lab_pg" {
  description = "Nested Port-Group for network connectivity."
  type        = string
}

// DNS
variable "dns" {
  type = string
}

// NTP
variable "ntp" {
  type = string
}

// Search Domains
variable "search_domain" {
  description = "Search domain."
  type        = string
}

variable "management_network_info" {
  description = "Map of management network info"
  type        = map(string)
  default = {
    #gateway = "10.0.0.1"
    #subnetmask = "255.255.255.0"
    #vlan = "#"
  }
}

// Host Credentials
variable "passwords" {
  description = "Map of Passwords"
  type        = map(string)
  default = {
    #admin = "VMware1!VMware1!"
    #root = "VMware1!VMware1!"
  }
  sensitive = true
}

// Guest ID
variable "guest_version" {
  description = "VM Guest version"
  type        = string
  default = "vmkernel8Guest"
}

// Disk Sizes 
variable "cache_disk_size" {
  description = "Size in GB of the vSAN cache disk. Required for OSA"
  type        = number
  default     = 250
}

variable "data_disk_size" {
  description = "Size in GB of the vSAN data disk."
  type        = number
  default     = 500
}

// CPU Info
variable "host_cpus" {
  description = "Number of total vCPUs."
  type        = number
  default     = 24
}

variable "host_cores" {
  description = "Number of total Cores per socket."
  type        = number
  default     = 12
}

// Host Memory
variable "host_mem" {
  description = "Size of system memory, in MB."
  type        = number
  default     = 131072
}

// Host Uplinks
variable "host_uplinks" {
  description = "Number of uplinks to assign to each ESXi host."
  type        = map(string)
  default = {
    1 = "uplink1"
    2 = "uplink2"
  }
}