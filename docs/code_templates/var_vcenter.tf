variable "vcenter_server" {
  description = "FQDN of the vCenter API endpoint."
  type        = string
}
variable "vcenter_username" {
  description = "Username to authenticate."
  type        = string
  default     = "administrator@vsphere.local"
}
variable "vcenter_password" {
  description = "Password of the associated username."
  type        = string
  default     = "VMware1!VMware1!"
}