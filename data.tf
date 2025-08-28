# tflint-ignore: terraform_unused_declarations
data "oci_identity_availability_domains" "oci_identity_availability_domains" {
  compartment_id = local.compartment_id
}

# First, get all instances with the specific tag
data "oci_core_private_ips" "instance_private_ips" {
  for_each = local.instances_needing_public_ip

  subnet_id  = var.subnets[each.value.subnet_index]
  ip_address = oci_core_instance.oci_instances[each.key].private_ip
}