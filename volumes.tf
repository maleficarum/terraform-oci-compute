resource "oci_core_volume" "volumes" {
  count               = length(var.instance_configuration)
  availability_domain = data.oci_identity_availability_domains.oci_identity_availability_domains.availability_domains[0].name

  compartment_id = local.compartment_id
  display_name   = var.instance_configuration[count.index].name != "" ? "${var.instance_configuration[count.index].name}-volume" : "${var.environment}-vm-volume-${count.index}"
  size_in_gbs    = var.instance_configuration[count.index].storage_size

  defined_tags = {
    "Oracle-Tags.CreatedBy"   = "default/terraform-cae",
    "Oracle-Tags.Environment" = var.environment
    "Oracle-Tags.Application" = var.application_name
  }

}

resource "oci_core_volume_attachment" "volume_attachment" {
  count           = length(var.instance_configuration)
  attachment_type = "paravirtualized"
  instance_id     = oci_core_instance.oci_instances[count.index].id
  volume_id       = oci_core_volume.volumes[count.index].id
}