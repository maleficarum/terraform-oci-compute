locals {
  instances_needing_public_ip = {
    for i, instance in var.instance_configuration : i => instance
    if try(instance.reserved_public_ip, false) == true
  }
}