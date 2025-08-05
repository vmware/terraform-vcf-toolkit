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

//Port-Groups
variable "port_group_mgmt" {
  description = "Port-Group for the MGMT / External interface."
  type        = string
}
variable "port_group_vm" {
  description = "Port-Group for the VM Network."
  type        = string
}
# --------------------------------------------------------------- #
# HCI Bench VM Configuration (2.8.2)
# https://github.com/vmware-labs/hci-benchmark-appliance/tree/main
#
# vAPP Options:
# - Public_Network_Gateway
# - Public_Network_IP
# - Public_Network_Size
# - Public_Network_Type
# - IP_Version
# - DNS
# - System_Password
# --------------------------------------------------------------- #
//Local Path
variable "local_ovf_path" {
  description = "File location OVA/OVF."
  type        = string
  #default = "E:\\appliance.ova"
}

//Non-Sensitive Config
variable "vm_settings" {
  description = "Standard vAPP settings for the Cloud Builder appliance."
  type        = map(string)
  default = {
    #vm_name = "hci_bench"
    #public_network_gateway = ""
    #public_network_ip = ""
    #public_network_size = 24
    #public_network_type = "DHCP" // One of DHCP, Static, Autoconf
    #ip_version          = "IPV4" // IPV4, IPV6
    #dns = ""
    #system_password = "VMware1!"
  }
}

//Sensitive Config
variable "appliance_password" {
  description = "Passwords for Admin and Root for the Cloud Builder appliance"
  type        = string
  sensitive   = true
}
