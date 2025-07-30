variable "datacenter" {
  description = "vCenter Datacenter name."
  type        = string
}

variable "cluster" {
  description = "vCenter Cluster name."
  type        = string
}

variable "vms" {
  description = "Virtual Machines to add into the affinity group."
  type        = list(string)
}

variable "rule_name" {
  description = "Name of the affinity group where VMs will run together."
  type        = string
}