output "ad" {
  value       = data.oci_identity_availability_domains.oci_identity_availability_domains
  description = "value"
}

output "instances_ips" {
  value = flatten(oci_core_instance.oci_instances[*].create_vnic_details[*].private_ip)
  description = "The created instances"
}

output "instances_names" {
  value = flatten(oci_core_instance.oci_instances[*].display_name)
  description = "The created instances"
}