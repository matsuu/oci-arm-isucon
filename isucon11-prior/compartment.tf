resource "oci_identity_compartment" "isucon" {
  compartment_id = var.tenancy_ocid
  description    = var.description
  name           = var.name
}

resource "time_sleep" "wait_5_seconds" {
  create_duration = "5s"

  depends_on = [oci_identity_compartment.isucon]
}

resource "oci_core_vcn" "isucon" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = oci_identity_compartment.isucon.id
  display_name   = var.name
  dns_label      = var.name

  lifecycle {
    ignore_changes = [
      defined_tags,
      dns_label,
    ]
  }

  depends_on = [time_sleep.wait_5_seconds]
}

resource "oci_core_internet_gateway" "isucon" {
  compartment_id = oci_identity_compartment.isucon.id
  display_name   = var.name
  vcn_id         = oci_core_vcn.isucon.id
}

resource "oci_core_default_route_table" "isucon" {
  manage_default_resource_id = oci_core_vcn.isucon.default_route_table_id
  display_name               = var.name

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.isucon.id
  }
}

resource "oci_core_subnet" "isucon" {
  #availability_domain = data.oci_identity_availability_domain.ad.name
  cidr_block     = cidrsubnet(oci_core_vcn.isucon.cidr_block, 8, 10)
  display_name   = var.name
  dns_label      = var.name
  compartment_id = oci_identity_compartment.isucon.id
  vcn_id         = oci_core_vcn.isucon.id

  lifecycle {
    ignore_changes = [
      defined_tags,
      dns_label,
    ]
  }
}

data "oci_identity_availability_domain" "ad" {
  compartment_id = oci_identity_compartment.isucon.id
  ad_number      = 1
}
