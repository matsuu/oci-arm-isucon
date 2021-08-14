resource "oci_core_instance" "bench" {
  count               = var.num_instances["bench"]
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = oci_identity_compartment.isucon.id
  display_name        = "bench${count.index + 1}"
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.shape_ocpus["bench"]
    memory_in_gbs = var.shape_memories["bench"]
  }

  create_vnic_details {
    subnet_id                 = oci_core_subnet.isucon.id
    display_name              = "bench${count.index + 1}"
    assign_public_ip          = true
    assign_private_dns_record = true
    hostname_label            = "bench${count.index + 1}"
    nsg_ids                   = [oci_core_network_security_group.bench.id]
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu.images.0.id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
    user_data           = base64encode(file("./userdata/bench"))
  }

  lifecycle {
    ignore_changes = [
      source_details.0.source_id,
      metadata,
    ]
  }
}

resource "oci_core_network_security_group" "bench" {
  compartment_id = oci_identity_compartment.isucon.id
  vcn_id         = oci_core_vcn.isucon.id
  display_name   = "bench"
}

resource "oci_core_network_security_group_security_rule" "bench-egress-all" {
  network_security_group_id = oci_core_network_security_group.bench.id
  direction                 = "EGRESS"
  protocol                  = "all"

  #description = ""

  destination      = "0.0.0.0/0"
  destination_type = "CIDR_BLOCK"
}

