# --------------------------------------------------------------- #
# vCenter Configuration
# --------------------------------------------------------------- #

// Datacenter
variable "datacenter" {
  description = "Datacenter to deploy the VM."
  type        = string
}
// Cluster Name
variable "cluster" {
  description = "Cluster to deploy the VM."
  type        = string
}
// Deployment Host
variable "deployment_host" {
  description = "ESXi host where the VM will be deployed."
  type        = string
}
// Datastore
variable "datastore" {
  description = "Datastore to deploy the VM."
  type        = string
}

// VDS
variable "vds" {
  description = "Virtual Distributed Switch"
  type        = string
}

//Port-Group
variable "port_group" {
  description = "Port-Group to deploy VM management interface of the VM."
  type        = string
}

// Folder
variable "folder" {
  description = "Folder for VM organization."
  default     = "vm"
}

// Resource Pool
variable "resource_pool" {
  description = "Cluster Resource Pool."
  default     = null
}

// Content Library
variable "content_library" {
  description = "Name of the Content LIbrary."
  type = object({
    name = string
    item = string
  })
}
# --------------------------------------------------------------- #
# SSP Installer VM Configuration
#
# The space separated DNS server list for this VM (valid only if an IPv4 address is specified for the interface).
# NOTE: At most three name servers can be configured (first 3 name servers passed in list will be used and all other will be ignored)
# --------------------------------------------------------------- #
//Non-Sensitive Config
variable "ova_settings" {
  description = "Standard vAPP settings for the OVA template."
  type = object({
    fqdn        = string
    ip          = string
    netmask     = string
    gateway     = string
    domain_list = string
    ntp         = string
    ssh         = optional (bool, true)
    grub_menu_timeout    = optional (number, 4)
  })
}

//Sensitive Config
variable "ova_passwords" {
  description = "Passwords for the OVA template"
  type        = map(string)
  default = {
    grub_pass  = "VMware1!VMware1!"
    admin_pass = "VMware1!VMware1!"
    audit_pass = "VMware1!VMware1!"
  }
  sensitive = true

  validation {
    condition     = length(var.ova_passwords) < 12
    error_message = "Password minimum is 12 characters."
  }
}