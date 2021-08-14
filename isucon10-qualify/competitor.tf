resource "oci_core_instance" "competitor" {
  count               = var.num_instances["competitor"]
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = oci_identity_compartment.isucon.id
  display_name        = "competitor${count.index + 1}"
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.shape_ocpus["competitor"]
    memory_in_gbs = var.shape_memories["competitor"]
  }

  create_vnic_details {
    subnet_id                 = oci_core_subnet.isucon.id
    display_name              = "competitor${count.index + 1}"
    assign_public_ip          = true
    assign_private_dns_record = true
    hostname_label            = "competitor${count.index + 1}"
    nsg_ids                   = [oci_core_network_security_group.competitor.id]
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu.images.0.id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
    user_data           = base64encode(file("./userdata/competitor"))
  }

  lifecycle {
    ignore_changes = [
      source_details.0.source_id,
      metadata,
    ]
  }
}

resource "oci_core_network_security_group" "competitor" {
  compartment_id = oci_identity_compartment.isucon.id
  vcn_id         = oci_core_vcn.isucon.id
  display_name   = "competitor"
}

resource "oci_core_network_security_group_security_rule" "competitor-ingress-http" {
  network_security_group_id = oci_core_network_security_group.competitor.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP

  description = "HTTP from internet"

  source      = var.source_cidr
  source_type = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      max = 80
      min = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "competitor-ingress-bench" {
  network_security_group_id = oci_core_network_security_group.competitor.id
  direction                 = "INGRESS"
  protocol                  = "all"

  description = "all from bench"

  source      = oci_core_network_security_group.bench.id
  source_type = "NETWORK_SECURITY_GROUP"
}

resource "oci_core_network_security_group_security_rule" "competitor-ingress-competitor" {
  network_security_group_id = oci_core_network_security_group.competitor.id
  direction                 = "INGRESS"
  protocol                  = "all"

  description = "all from competitor"

  source      = oci_core_network_security_group.competitor.id
  source_type = "NETWORK_SECURITY_GROUP"
}

resource "oci_core_network_security_group_security_rule" "competitor-egress-all" {
  network_security_group_id = oci_core_network_security_group.competitor.id
  direction                 = "EGRESS"
  protocol                  = "all"

  #description = ""

  destination      = "0.0.0.0/0"
  destination_type = "CIDR_BLOCK"
}
