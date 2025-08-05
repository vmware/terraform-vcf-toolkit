# --------------------------------------------------------------- #
# Variables
# --------------------------------------------------------------- #
variable "datacenter" {
  description = "Name of the Datacenter."
  type        = string
}

variable "datastore" {
  description = "Name of the Datastore to use as the storage backing of the Content Library."
  type        = string
}

variable "content_library" {
  description = "Content Library configuration parameters."
  type = object({
    name        = string
    description = optional(string, "Content Library")
    published   = optional(bool, false)
  })
}