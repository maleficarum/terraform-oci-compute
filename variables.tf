# tflint-ignore: terraform_unused_declarations
variable "instance_configuration" {
  description = "Instance parameters"
  type = list(
    object({
      name                      = string,
      ssh_public_key            = string,
      assign_ipv6ip             = string,
      assign_private_dns_record = string,
      assign_public_ip          = string,
      state                     = string, # [RUNNING, STOPPED]
      shape_config = object({
        type   = string,
        memory = number,
        ocpus  = number
      }),
      image       = string,
      compartment = string
    })
  )
}

variable "subnet" {
  type        = string
  description = "The ID of the target subnet"
}

#variable "reserved_ips" {
#  type = list(object({
#    ip_address = string,
#    public_ip_pool_id =string
#  }))
#  description = "Reserved IPS"
#}

variable "compartment_id" {
  type        = string
  description = "This compartment ID is for global queries. No resource will be deployed in this compartment"
}

variable "environment" {
  type        = string
  description = "The deployed compartment"
}