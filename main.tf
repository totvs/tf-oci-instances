
resource "oci_core_instance" "instance" {
  
  for_each = var.oci_instances
  
  availability_domain = each.value["availability_domain"]
  compartment_id = each.value["compartment_id"]
  shape = each.value["shape"]

  create_vnic_details {
    nsg_ids = each.value.create_vnic_details.nsg_ids
    subnet_id = each.value.create_vnic_details.subnet_id
      
  }

  display_name = each.value["display_name"]

  shape_config {
    baseline_ocpu_utilization = each.value.shape_config.baseline_ocpu_utilization
    memory_in_gbs = each.value.shape_config.memory_in_gbs
    ocpus = each.value.shape_config.ocpus
    vcpus = each.value.shape_config.vcpus
  }

  source_details {
    source_id = each.value.source_details.source_id
    source_type = each.value.source_details.source_type
    boot_volume_size_in_gbs = each.value.source_details.boot_volume_size_in_gbs
    boot_volume_vpus_per_gb = each.value.source_details.boot_volume_vpus_per_gb
    instance_source_image_filter_details {
      compartment_id = each.value.source_details.instance_source_image_filter_details.compartment_id
    }
  }
  
  metadata = {
    ssh_authorized_keys = each.value.metadata.ssh_authorized_keys
  } 
  
  preserve_boot_volume = each.value["preserve_boot_volume"]
}

