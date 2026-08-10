variable "datacenter" {
    type = string
    description = "Datacenter name."
}
variable "cluster" {     
    type = string
    description = "Cluster name."
}
variable "vm_tag_mapping" {
    type = map(object({
        tags = list(object({
            tag = string
            scope = string
        }))
    }))
    

    description = "List of Virtual Machines (to be discovered) and NSX Tags (to create and apply)."
}