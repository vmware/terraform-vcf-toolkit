// Datacenter
variable "datacenter" {
  description = "Datacenter"
  type        = string
}

// Cluster Name
variable "cluster" {
  description = "vSphere Cluster"
  type        = string
}

// ESXi Host Name
variable "deployment_host" {
  description = "vSphere ESXi Host"
  type        = string
}

// Datastore
variable "datastore" {
  description = "Datastore"
  type        = string
}

// Virtual Distributed Switch
variable "vds" {
  description = "Virtual Distributed Switch"
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

// OVF Template
variable "local_ova_path" {
  description = "Local OVA to deploy the VyOS automation appliance."
  type        = string
}

// Port-Group - External
variable "external_pg" {
  description = "External - WAN, generally a management/routable interface."
  type        = string
}

// Port-Group - External
variable "internal_pg" {
  description = "Internal - LAN, lab facing networking / RFC1918 space."
  type        = string
}

# --------------------------------------------------------------- #
# VyOS VM Configuration
# --------------------------------------------------------------- #

// Password
variable "password" {
  description = "Appliance password."
  type        = string
  default     = "VMware1!"
  sensitive   = true
}

// VM Settings
variable "vm_settings" {
  description = "VM Settings / OVF Properties. Use these settings if you are not importing user-data (config.yml)."
  type        = map(string)
  /*
  default = {
    vm_name       = "vyos-router"
    domain_suffix = "sddc.lab"
    wan_ip        = "10.0.1.5"
    mask          = "255.255.255.0"
    gateway       = "10.0.1.1"
    dns           = "10.0.1.2"
    ntp           = "10.0.1.2"
    user-data     = filebase64(string) > from config.yaml
  } */
}

variable "vyos_config" {
  description = "Path to config.yaml for customization."
  type        = string
  default     = "../config_setup1.yaml"
}