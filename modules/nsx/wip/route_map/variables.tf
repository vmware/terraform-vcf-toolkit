# --------------------------------------------------------------- #
# Route-Map Variables
# --------------------------------------------------------------- #
// Tier-0 Logical-Router
variable "t0_name" {
  description = "Tier-0 Logical-Router name."
  type        = string
}

// Segments to advertise
variable "segments_out" {
  description = "Subnet in CIDR format for each Segment to be added into the outbound Prefix List."
  type        = list(string)
  default     = [""]
}

// Segments to receive
variable "segments_in" {
  description = "Subnet in CIDR format for each Segment to be added into inbound the Prefix List."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}