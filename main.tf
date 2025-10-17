
resource "oci_core_instance" "instance" {
  
  for_each = var.oci_instances
  
  availability_domain = each.value["availability_domain"]
  compartment_id = each.value["compartment_id"]
  shape = each.value["shape"]

  create_vnic_details {
    nsg_ids = each.value.create_vnic_details.nsg_ids
    subnet_id = each.value.create_vnic_details.subnet_id
    assign_public_ip = each.value.create_vnic_details.assign_public_ip
    network_type = each.value.create_vnic_details.network_type
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


resource "oci_core_volume" "volume" {
  
  for_each = var.oci_volumes
  
  compartment_id = each.value["compartment_id"]
  availability_domain = each.value["availability_domain"]
  display_name = each.value["display_name"]
  size_in_gbs = each.value["size_in_gbs"]
  vpus_per_gb = each.value["vpus_per_gb"]

  is_auto_tune_enabled = each.value["is_auto_tune_enabled"]
  
  autotune_policies {
    autotune_type = each.value.autotune_policies.autotune_type
    max_vpus_per_gb = each.value.autotune_policies.max_vpus_per_gb
  }

}

resource "oci_core_volume_attachment" "volume_attachment" {
  
  for_each = var.oci_volumes

  attachment_type = each.value["attachment_type"]
  instance_id = oci_core_instance.instance[each.value.instance_to_attach].id
  volume_id = oci_core_volume.volume[each.key].id
  
}
