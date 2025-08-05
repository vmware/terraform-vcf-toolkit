variable "nsx_manager" {}
variable "nsx_username" {}
variable "nsx_password" {}

# --------------------------------------------------------------- #
# Discover Components
# --------------------------------------------------------------- #
variable "host_switch_uuid" {
  description = "VDS Switch ID to use during Host Transport-Node Profile creation/application.  https://{manager}/api/v1/fabric/virtual-switches"
  type        = string
}

variable "ip_pool" {
  description = "Name of the existing IP Pool to use."
  type        = string
}

variable "uplink_profile" {
  description = "Name of the existing Uplink-Profile of the Cluster."
  type        = string
}

variable "tz_overlay" {
  description = "Name of the existing Overlay Transport-Zone of the Cluster."
  type        = string
}

# --------------------------------------------------------------- #
# New NSX Components
# --------------------------------------------------------------- #
variable "ha_tep_profile" {
  description = "New High-Availability Tunnel-Endpoint Profile."
  type = object({
    name             = string
    description      = optional(string, "HA TEP Profile.")
    wait             = optional(number, 300)
    backoff          = optional(number, 86400)
    auto_recovery    = optional(bool, true)
    enabled          = optional(bool, false)
    failover_timeout = optional(number, 5)
  })
}


variable "host_tnp" {
  description = "New Transport-Node Profile.  This will contain both the new HA-TEP Profile and the previously created TNP already applied to the Cluster."
  type = object({
    name           = string
    uplink_mapping = map(string) # VDS Uplink name = NSX Uplink name
    switch_mode    = optional(string, "STANDARD")
  })
}