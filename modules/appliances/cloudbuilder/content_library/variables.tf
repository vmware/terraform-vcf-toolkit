# --------------------------------------------------------------- #
# vCenter Configuration
# --------------------------------------------------------------- #

// Datacenter
variable "datacenter" {
  description = "Datacenter to deploy the Cloud Builder VM."
  type        = string
}
// Cluster Name
variable "cluster" {
  description = "Cluster to deploy the Cloud Builder VM."
  type        = string
}
// Deployment Host
variable "deployment_host" {
  description = "ESXi host where the Cloud Builder VM will be deployed."
  type        = string
}
// Datastore
variable "datastore" {
  description = "Datastore to deploy the Cloud Builder VM."
  type        = string
}

// VDS
variable "vds" {
  description = "Virtual Distributed Switch"
  type        = string
}

//Port-Group
variable "port_group" {
  description = "Port-Group to deploy VM management interface of the Cloud Builder appliance."
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
# Cloud Builder VM Configuration
#
# vAPP Options:
# - FIPS_ENABLE (optional / default = False)
# - guestinfo.ADMIN_USERNAME (default = admin)
# - guestinfo.ADMIN_PASSWORD
# - guestinfo.ROOT_PASSWORD
# - guestinfo.hostname
# - guestinfo.ip0
# - guestinfo.netmask0
# - guestinfo.domain
# - guestinfo.searchpath
# - guestinfo.ntp
# --------------------------------------------------------------- #
//Non-Sensitive Config
variable "cloud_builder_settings" {
  description = "Standard vAPP settings for the Cloud Builder appliance."
  type        = map(string)
  #hostname = ""
  #ip = ""
  #netmask = ""
  #domain = ""
  #searchpath = ""
  #ntp = ""
}

//Sensitive Config
variable "cloud_builder_passwords" {
  description = "Passwords for Admin and Root for the Cloud Builder appliance"
  type        = map(string)
  #admin_user = ""
  #admin_pass = ""
  #root_pass = ""
  sensitive = true

  validation {
    condition     = length(var.cloud_builder_passwords) < 8
    error_message = "Password minimum is 8 characters."
  }
}