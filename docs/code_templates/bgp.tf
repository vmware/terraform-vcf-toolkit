variable "bgp_config_simple" {
  description = "Configuration suitable for a single fault-domain."
  type        = map(string)
  default = {
    asn_remote = "65534"
    asn_local  = "65535"
    password   = "Password1!"
    keepalive  = "4"
    timer      = "12"
    peer_1     = "1.1.1.1/31"
    peer_2     = "2.2.2.1/31"
  }
}

variable "bgp_config_simple" {
  description = "Configuration suitable for a single fault-domain."
  type = object({
    asn_remote = string
    asn_local  = string
    password   = string
    keepalive  = optional(string, "4")
    timer      = optional(string, "12")
    peer_1     = string
    peer_2     = string
  })
}

variable "bgp_config_advanced" {
  description = "Configuration suitable for a mutliple fault-domains."
  type        = map(map(string))
  default = {
    fault_domain_1 = {
      asn_remote = "65530"
      asn_local  = "65535"
      password   = "Password1!"
      keepalive  = "4"
      timer      = "12"
      peer_1     = "1.1.1.1/31"
      peer_2     = "2.2.2.1/31"
    },
    fault_domain_2 = {
      asn_remote = "65531"
      asn_local  = "65535"
      password   = "Password1!"
      keepalive  = "4"
      timer      = "12"
      peer_1     = "1.1.1.1/31"
      peer_2     = "2.2.2.1/31"
    }
  }
}