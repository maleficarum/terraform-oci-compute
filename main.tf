resource "oci_identity_compartment" "compute_compartment" {
  compartment_id = var.compartment_id
  description    = "Compartment for compute resources"
  name           = "compute"
}

resource "oci_core_instance" "oci_instances" {

  count                = length(var.instance_configuration)
  state                = var.instance_configuration[count.index].state
  preserve_boot_volume = true

  agent_config {
    is_management_disabled = "false"
    is_monitoring_disabled = "false"
    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Oracle Java Management Service"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "OS Management Service Agent"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "OS Management Hub Agent"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Management Agent"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Custom Logs Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute RDMA GPU Monitoring"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Run Command"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute HPC RDMA Auto-Configuration"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Compute HPC RDMA Authentication"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Cloud Guard Workload Protection"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Block Volume Management"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }

  availability_config {
    recovery_action = "RESTORE_INSTANCE"
  }

  availability_domain = data.oci_identity_availability_domains.oci_identity_availability_domains.availability_domains[0].name
  compartment_id      = oci_identity_compartment.compute_compartment.id
  #public_ip        =    length(var.reserved_ips) == length(var.instance_configuration) ? var.reserved_ips[count.index].public_ip : null


  create_vnic_details {
    assign_ipv6ip             = var.instance_configuration[count.index].assign_ipv6ip
    assign_private_dns_record = var.instance_configuration[count.index].assign_private_dns_record
    assign_public_ip          = var.instance_configuration[count.index].reserved_public_ip ? false : var.instance_configuration[count.index].assign_public_ip
    subnet_id                 = var.subnets[var.instance_configuration[count.index].subnet_index]
  }


  display_name = var.instance_configuration[count.index].name != "" ? var.instance_configuration[count.index].name : "${var.environment}-vm-${count.index}"

  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }

  is_pv_encryption_in_transit_enabled = "true"

  metadata = {
    #"ssh_authorized_keys" = var.instance_configuration[count.index].ssh_public_key
    ssh_authorized_keys = join("\n", var.instance_configuration[count.index].ssh_public_key)
    #user_data           = fileexists(var.instance_configuration[count.index].cloud_init_file) ? base64encode(file(var.instance_configuration[count.index].cloud_init_file)) : null
    user_data = base64encode(file("${var.cloud_init_file}-${count.index + 1}"))
  }

  shape = var.instance_configuration[count.index].shape_config.type

  shape_config {
    memory_in_gbs = var.instance_configuration[count.index].shape_config.memory
    ocpus         = var.instance_configuration[count.index].shape_config.ocpus
  }

  source_details {
    source_id   = var.instance_configuration[count.index].image
    source_type = "image"
  }

  defined_tags = {
    "Oracle-Tags.CreatedBy"   = "default/terraform-cae",
    "Oracle-Tags.Environment" = var.environment
    "Oracle-Tags.Application" = var.instance_configuration[count.index].application_name == "" ? var.application_name : var.instance_configuration[count.index].application_name
  }

  freeform_tags = {
    "reserved_public_ip" = var.instance_configuration[count.index].reserved_public_ip == "" ? false : var.instance_configuration[count.index].reserved_public_ip
  }

}

# resource "oci_core_public_ip" "assigned_ips" {
#   #count = length(var.instance_configuration) == var.reserved_ips ? length(var.instance_configuration) : 0
#   count = length(var.instance_configuration)

#   compartment_id = var.network_compartment
#   lifetime       = "RESERVED"
#   display_name   = "reserved-ip-for-${oci_core_instance.oci_instances[count.index].display_name}"

#   # This remains the same as it gets the private IP ID from the data source
#   private_ip_id = data.oci_core_private_ips.instance_private_ips[count.index].private_ips[0].id

#   lifecycle {
#     prevent_destroy = false
#     ignore_changes = [
#       private_ip_id,
#       display_name
#     ]
#   }
# }

resource "oci_core_public_ip" "assigned_ips" {
  for_each = local.instances_needing_public_ip

  compartment_id = var.network_compartment
  lifetime       = "RESERVED"
  display_name   = "reserved-ip-for-${oci_core_instance.oci_instances[each.key].display_name}"
  private_ip_id  = data.oci_core_private_ips.instance_private_ips[each.key].private_ips[0].id
}