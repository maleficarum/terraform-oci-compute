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
  compartment_id      = var.compartment_id

  create_vnic_details {
    assign_ipv6ip             = var.instance_configuration[count.index].assign_ipv6ip
    assign_private_dns_record = var.instance_configuration[count.index].assign_private_dns_record
    assign_public_ip          = var.instance_configuration[count.index].assign_public_ip
    subnet_id                 = var.subnet
  }

  display_name = "${var.instance_configuration[count.index].name}-${count.index}-vm"

  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }

  is_pv_encryption_in_transit_enabled = "true"

  metadata = {
    "ssh_authorized_keys" = var.instance_configuration[count.index].ssh_public_key
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
        "Oracle-Tags.CreatedBy" = "default/terraform",
        "Oracle-Tags.Environment" = var.environment 
      }

}