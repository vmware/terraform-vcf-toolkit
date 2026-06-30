variable "services" {
  description = "Defined Services for re-use."
  type        = map(object({
    protocol = string
    port     = list(string)
  }))
}