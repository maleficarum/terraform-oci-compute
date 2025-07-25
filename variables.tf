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
      storage_size = number,
      image       = string
    })
  )
}

variable "subnet" {
  type        = string
  description = "The OCID of the target subnet"
}

variable "reserved_ips" {
  type = number
  default = 0
  description = "Reserved IPS"
}

variable "compartment_id" {
  type        = string
  description = "This is the parent compartment (OCID). A compute compartment will be created inside this. No resource will be deployed in this compartment"
}

variable "network_compartment" {
  type = string
  description = "The network compartment (OCID) where the reserved public IPs will be created"
}

variable "environment" {
  type        = string
  description = "The deployed compartment"
}

variable "cloud_init_file" {
  type = string
  default = ""
  description = "The init file that has the commands to execute on the VM creation"
}

variable "application_name" {
  type = string
  default = "General"
  description = "The application name that will be deployed over this resource"
}