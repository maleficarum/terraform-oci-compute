# Create volumes - one for each block_volumes entry per instance
resource "oci_core_volume" "volumes" {
  for_each = { for idx, vol in local.all_volumes : "${vol.instance_index}.${vol.volume_index}" => vol }

  availability_domain = data.oci_identity_availability_domains.oci_identity_availability_domains.availability_domains[0].name
  compartment_id      = local.compartment_id
  display_name        = each.value.instance_name != "" ? "${each.value.instance_name}-volume-${each.value.volume_index + 1}" : "${var.environment}-vm-${each.value.instance_index}-volume-${each.value.volume_index + 1}"
  size_in_gbs         = each.value.storage_size
  vpus_per_gb         = each.value.vpus_per_gb

  defined_tags = {
    "Oracle-Tags.CreatedBy"   = "default/terraform-cae",
    "Oracle-Tags.Environment" = var.environment
    "Oracle-Tags.Application" = each.value.application_name
  }
}

# Attach each volume to its corresponding instance
resource "oci_core_volume_attachment" "volume_attachment" {
  for_each = { for idx, vol in local.all_volumes : "${vol.instance_index}.${vol.volume_index}" => vol }

  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.oci_instances[each.value.instance_index].id
  volume_id       = oci_core_volume.volumes["${each.value.instance_index}.${each.value.volume_index}"].id
}

# resource "oci_core_volume" "volumes" {
#   count               = length(var.instance_configuration)
#   availability_domain = data.oci_identity_availability_domains.oci_identity_availability_domains.availability_domains[0].name

#   compartment_id = local.compartment_id
#   display_name   = var.instance_configuration[count.index].name != "" ? "${var.instance_configuration[count.index].name}-volume" : "${var.environment}-vm-volume-${count.index}"
#   size_in_gbs    = var.instance_configuration[count.index].storage_size

#   defined_tags = {
#     "Oracle-Tags.CreatedBy"   = "default/terraform-cae",
#     "Oracle-Tags.Environment" = var.environment
#     "Oracle-Tags.Application" = var.application_name
#   }

# }

# resource "oci_core_volume_attachment" "volume_attachment" {
#   count           = length(var.instance_configuration)
#   attachment_type = "paravirtualized"
#   instance_id     = oci_core_instance.oci_instances[count.index].id
#   volume_id       = oci_core_volume.volumes[count.index].id
# }

