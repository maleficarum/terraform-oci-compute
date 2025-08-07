# tflint-ignore: terraform_unused_declarations
data "oci_identity_availability_domains" "oci_identity_availability_domains" {
  compartment_id = var.compartment_id
}

data "oci_core_private_ips" "instance_private_ips" {
  count      = length(var.instance_configuration) == var.reserved_ips ? length(var.instance_configuration) : 0
  subnet_id  = var.subnets[var.instance_configuration[count.index].subnet_index]
  ip_address = oci_core_instance.oci_instances[count.index].private_ip
}