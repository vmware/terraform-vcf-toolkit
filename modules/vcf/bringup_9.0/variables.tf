# --------------------------------------------------------------- #
# VCF Bring Up Module - Management Domain / SDDC Instance
# - Assumes a VCF Installer Appliance is available
# - Configures available hosts for a Management Cluster
# - Deploys VCF SDDC Management Appliance
# - Deploys vCenter and NSX Appliances for the Management Domain
# - (Optional) Deploys VCF Fleet Manager
# - (Optional) Deploys VCF Operations
# - (Optional) Deploys VCF Automation
# --------------------------------------------------------------- #

# --------------------------------------------------------------- #
# Environment Variables
# --------------------------------------------------------------- #
variable "domain_suffix" {
  description = "Domain suffix for appliances and hosts."
  type        = string
}

variable "dns" {
  description = "DNS servers for name resolution."
  type        = list(string)

  validation {
    condition     = length(var.dns) <= 2
    error_message = "Two (2) or less DNS servers supported."
  }
}

variable "ntp" {
  description = "NTP servers for time synchronization."
  type        = list(string)
  default = [
    "pool.ntp.org",
  ]

  validation {
    condition     = length(var.ntp) <= 2
    error_message = "Two (2) or less NTP servers supported."
  }
}

variable "ceip" {
  description = "Customer Experience Improvement Program"
  type        = bool
  default     = true
}
# --------------------------------------------------------------- #
# SDDC Configuration - Network Pool(s) Settings
# --------------------------------------------------------------- #
/*
variable "network_pools" {
  description = "SDDC Manager Network Pool for IP allocation tracking in the Management Domain/Cluster."
  type = object({
    name = string
    vlan = string
    mtu = string
    subnet = string
    gateway = string
    include_range = list(string) # start ip, end ip
  })

  validation {
    condition = can(cidrhost(var.network_pools.subnet, 0))
    error_message = "Subnet must be in CIDR notation.  Example - 10.0.0.0/24"
  }

  validation {
    condition = var.network_pools.vlan > 0 && var.network_pools.vlan < 4095
    error_message = "Supported VLAN IDs must be between 1 and 4095."
  }
} */

variable "network_pool_mgmt_appliances" {
  description = "Network pool for VCF Appliances."
  type        = map(string)
  default = {
    #subnet_cidr = "10.0.0.0/24"
    #gateway = "10.0.0.1"
    #vlan = "10"
    #mtu = 9000
    #port_group_name = "sddc_mgmt_appliances"
  }
}

variable "network_pool_mgmt_esxi" {
  description = "Network pool for ESXi hosts."
  type        = map(string)
  default = {
    #subnet_cidr = "10.0.1.0/24"
    #gateway = "10.0.1.1"
    #vlan = "11"
    #mtu = 9000
    #port_group_name = "sddc_esxi"
  }
}

variable "network_pool_mgmt_vmotion" {
  description = "Network pool for vMotion."
  type        = map(string)
  default = {
    #subnet_cidr = "10.0.2.0/24"
    #gateway = "10.0.2.1"
    #vlan = "12"
    #mtu = 9000
    #port_group_name = "sddc_vmotion"
    #range_start = "10.0.2.10"
    #range_end = "10.0.2.99"
  }
}

variable "network_pool_mgmt_vsan" {
  description = "Network pool for vSAN."
  type        = map(string)
  default = {
    #subnet_cidr = "10.0.3.0/24"
    #gateway = "10.0.3.1"
    #vlan = "13"
    #mtu = 9000
    #port_group_name = "vsan"
    #range_start = "10.0.3.10"
    #range_end = "10.0.3.99"
  }
}

variable "network_pool_mgmt_tep" {
  description = "Network pool for NSX Tunnel-Endpoints."
  type        = map(string)
  default = {
    #subnet_cidr = "10.0.4.0/24"
    #gateway = "10.0.4.1"
    #vlan = "14"
    #mtu = 9000
    #port_group_name = "host_tep"
    #range_start = "10.0.4.10"
    #range_end = "10.0.4.99"
    #tz_overlay_name = ""
  }
}
# --------------------------------------------------------------- #
# Management Domain - Appliance Variables
# --------------------------------------------------------------- #

variable "vcenter" {
  description = "vCenter appliance settings for the Management Domain."
  type = object({
    size          = optional(string, "medium") #tiny, small, medium, large, xlarge
    hostname      = string
    root_password = string
    storage_size  = optional(string, "lstorage")
  })
}

variable "nsx_cluster_appliances" {
  description = "NSX appliance cluster names."
  type        = list(string)
}

variable "nsx_cluster_settings" {
  description = "NSX appliance cluster settings for the Management Domain."
  type = object({
    size     = optional(string, "medium") # medium or large
    vip_fqdn = string
    passwords = object({
      admin = string
      root  = string
      audit = string
    })
    transport_zone_vlan = number
  })
}

variable "sddc_manager" {
  description = "SDDC appliance settings."
  type = object({
    hostname = string
    passwords = object({
      root  = string
      local = string #(admin@local)
      ssh   = string
    })
  })
}

# --------------------------------------------------------------- #
# Management Domain - Cluster Configuration
# --------------------------------------------------------------- #
variable "cluster_config" {
  description = "vSphere Cluster configuration."
  type = object({
    name            = string
    datacenter_name = string
    vsan = object({
      name  = optional(string)
      esa   = optional(bool, false)
      ftt   = optional(number, 1)
      dedup = optional(bool, false)
    })
  })
}

variable "vlcm" {
  description = "vSphere Lifecycle Manager images for cluster."
  type        = bool
  default     = true
}

variable "dvs" {
  description = "Distributed Virtual Switch settings for the Management Cluster."
  type = object({
    name = string
    mtu  = optional(string, 9000)
    uplink_mapping = list(object({
      uplink = string # Name uplink1, uplink2
      vmnic  = string # Name vmnic0, vmnic1, etc.
    }))
  })
}

variable "nioc_profiles" {
  description = "Network IO Control Share values."
  type        = map(string)
  default = {
    MANAGEMENT     = "NORMAL"
    VMOTION        = "LOW"
    VSAN           = "HIGH"
    VIRTUALMACHINE = "HIGH"
    NFS            = "LOW"
    FAULTTOLERANCE = "LOW"
    ISCSI          = "LOW"
    VDP            = "LOW"
    HBR            = "LOW"
  }
}
/*
  validation {
    condition = alltrue([
      for key in values(var.nioc_profiles) :
    contains("MANAGEMENT", "VMOTION", "VIRTUALMACHINE", "NFS", "FAULTTOLERANCE", "ISCSI", "VDP", "NBR")])
    error_message = "Does not contain a supported Share"
  }
} */
# --------------------------------------------------------------- #
# Host Commissioning
# --------------------------------------------------------------- #
variable "validate_thumbprint" {
  description = "Skip host thumbprint check, e.g. using self-signed certificates."
  type        = bool
  default     = true
}

variable "hosts" {
  description = "ESXi hosts to commisioning for the Management Cluster."
  type = list(object({
    hostname = string
    credentials = object({
      username = optional(string, "root")
      password = string
    })
  }))
  sensitive = true
}