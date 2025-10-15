# --------------------------------------------------------------- #
# vCenter Objects
# --------------------------------------------------------------- #
variable "datacenter" {
  description = "The name of the Datacenter."
}

variable "cluster" {
  description = "The name of the Compute Cluster."
}

variable "storage_policy_name" {
  description = "The name of the Storage Policy."
}

variable "content_library" {
  description = "The name of the subscribed Content Library"
}

variable "dvs" {
  description = "The name of the Distributed Virtual Switch."
}
# --------------------------------------------------------------- #
# NSX-T Objects
# --------------------------------------------------------------- #
variable "edge_cluster" {
  description = "The display name of the Edge-Cluster to be used."
  type        = string
}
# --------------------------------------------------------------- #
# Supervisor Cluster Variables
# --------------------------------------------------------------- #
variable "management_network" {
  description = "The name of the management network."
  type = object({
    name      = string
    mask      = string
    gateway   = string
    start_ip  = string
    pool_size = number
  })
}

variable "dns" {
  description = "DNS Server(s)."
  type        = map(string)
  #environment = "8.8.8.8"
  #worker = "8.8.8.8"
}

variable "ntp" {
  description = "NTP Server(s)"
  type = string
  default = "pool.ntp.org"
}

variable "search_domains" {
  description = "List of DNS servers."
  type        = list(string)
}

variable "k8s_api_size" {
  description = "Size of the k8s API server."
  type        = string
  default     = "SMALL" #"TINY", "SMALL", "MEDIUM", "LARGE"
}

variable "k8s_networks_ext" {
  description = "CIDR notation networks for the k8s infrastructure."
  type = object({
    ingress_net = string
    egress_net  = string
    service_net = string
  })
}

variable "pod_net" {
  description = "CIDR notation networks for the k8s Pods and Namespaces."
  type        = string
}