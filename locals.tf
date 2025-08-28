locals {
  instances_needing_public_ip = {
    for i, instance in var.instance_configuration : i => instance
    if try(instance.reserved_public_ip, false) == true
  }

# Determine compartment ID with validation
  compartment_id = (
    var.existing_compartment != "" ? 
    var.existing_compartment : 
    (length(oci_identity_compartment.compute_compartment) > 0 ? oci_identity_compartment.compute_compartment[0].id : var.compartment_id)
  )  
}
