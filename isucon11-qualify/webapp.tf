resource "oci_core_instance" "webapp" {
  count               = var.num_instances["webapp"]
  availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = oci_identity_compartment.isucon.id
  display_name        = "webapp${count.index + 1}"
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.shape_ocpus["webapp"]
    memory_in_gbs = var.shape_memories["webapp"]
  }

  availability_config {
    is_live_migration_preferred = true
  }

  create_vnic_details {
    subnet_id                 = oci_core_subnet.isucon.id
    display_name              = "webapp${count.index + 1}"
    assign_public_ip          = true
    assign_private_dns_record = true
    hostname_label            = "webapp${count.index + 1}"
    nsg_ids                   = [oci_core_network_security_group.webapp.id]
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu.images.0.id
  }

  metadata = {
    ssh_authorized_keys = var.ssh_authorized_keys
    user_data           = base64encode(file("./userdata/webapp"))
  }

  lifecycle {
    ignore_changes = [
      availability_domain,
      create_vnic_details.0.defined_tags,
      defined_tags,
      metadata,
      shape_config,
      source_details.0.source_id,
    ]
  }
}

resource "oci_core_network_security_group" "webapp" {
  compartment_id = oci_identity_compartment.isucon.id
  vcn_id         = oci_core_vcn.isucon.id
  display_name   = "webapp"
}

resource "oci_core_network_security_group_security_rule" "webapp-ingress-http" {
  network_security_group_id = oci_core_network_security_group.webapp.id
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

resource "oci_core_network_security_group_security_rule" "webapp-ingress-https" {
  network_security_group_id = oci_core_network_security_group.webapp.id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP

  description = "HTTPS from internet"

  source      = var.source_cidr
  source_type = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "webapp-ingress-webapp" {
  network_security_group_id = oci_core_network_security_group.webapp.id
  direction                 = "INGRESS"
  protocol                  = "all"

  description = "all from webapp"

  source      = oci_core_network_security_group.webapp.id
  source_type = "NETWORK_SECURITY_GROUP"
}

resource "oci_core_network_security_group_security_rule" "webapp-egress-all" {
  network_security_group_id = oci_core_network_security_group.webapp.id
  direction                 = "EGRESS"
  protocol                  = "all"

  #description = ""

  destination      = "0.0.0.0/0"
  destination_type = "CIDR_BLOCK"
}
