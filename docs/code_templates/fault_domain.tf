variable "fault_domain" {
  type = object({
    compute_manager = string
    datacenter      = string
    cluster         = string
    datastore       = string
    dvs             = string
  })
}