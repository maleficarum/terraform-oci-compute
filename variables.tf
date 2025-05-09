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
      image = string
    })
  )
}

variable "compartment_id" {
  type        = string
  description = "The compartment OCID to deploy the instances"
}

variable "subnet" {
  type        = string
  description = "The ID of the target subnet"
}