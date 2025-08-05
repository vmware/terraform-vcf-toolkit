# --------------------------------------------------------------- #
# Network Pool Configuration Variables
# --------------------------------------------------------------- #
variable "network_pool_type" {
  description = "VCF Network Pool object, acceptable types are VMOTION, VSAN, NFS or ISCSI."
  type = map(object({
    subnet   = string #not CIDR notation. e.g 10.0.0.0 
    gateway  = string
    mask     = string
    vlan     = number
    mtu      = number
    start_ip = optional(string, null)
    end_ip   = optional(string, null)
  }))
}

variable "network_pool_name" {
  description = "Name of the VCF Network Pool."
  type        = string
}