# --------------------------------------------------------------- #
# vCenter Configuration
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
  description = "Root Port-Group(s) for Nested Hosts/VMs. Default assumes VLAN tagging at Nested ESXi downstream."
  type        = map(list(string))
  default = {
    lab_trunk = [0, 4094]
  }
}
// Resource Pool
variable "root_rp" {
  description = "vCenter Resource Pool for Nested Lab VMs"
  type        = string
}
// Folder
variable "root_folder" {
  description = "vCenter Folder for Nested Lab VMs"
  type        = string
}

/*
# --------------------------------------------------------------- #
# Content Library Configuration
# --------------------------------------------------------------- #
// Content Library
variable "vmw_content_library_name" {
  description = "Name of the Content Library."
  type        = string
}

variable "vmw_content_library_ds" {
  description = "Datastore backing for the Content Library."
  type        = string
}

variable "vmw_content_library_subscription" {
  description = "URL for the Publishing Content Library"
  type        = string
} */