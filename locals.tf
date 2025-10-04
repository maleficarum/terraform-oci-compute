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

  # Flatten the structure: for each instance, for each volume in block_volumes
  all_volumes = flatten([
    for instance_idx, instance in var.instance_configuration : [
      for volume_idx, volume in instance.block_volumes : {
        instance_index   = instance_idx
        volume_index     = volume_idx
        instance_name    = instance.name
        storage_size     = volume.storage_size
        vpus_per_gb      = volume.vpus_per_gb
        application_name = instance.application_name != "" ? instance.application_name : var.application_name
      }
    ]
  ])
}
