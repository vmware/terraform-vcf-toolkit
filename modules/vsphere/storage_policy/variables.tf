# --------------------------------------------------------------- #
# vCenter Authentication Variables for post-deployment script.
# --------------------------------------------------------------- #
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

# --------------------------------------------------------------- #
# vCenter Storage Policy Configuration
# --------------------------------------------------------------- #
variable "tag_category" {
  description = "vSphere Resouce to organize Tags and associate to datastores and/or virtual machines."
  type = object({
    name         = string
    description  = optional(string, "")
    cardinality  = optional(string, "SINGLE") # or MULTIPLE
    object_types = list(string)
  })
}

variable "tags" {
  description = "vSphere Tags to associate with a Storage Policy."
  type = object({
    name        = string
    description = optional(string, "")
    category    = string #reference the Category name.
  })
}

variable "storage_policy" {
  description = "vSphere Storage Policy."
  type = object({
    tag_category_name = string,
    tag_name          = string,
    name              = string,
    description       = optional(string, ""),
    datastore = object({
      name       = string
      datacenter = string
    })
  })
}