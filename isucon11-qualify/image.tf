data "oci_core_images" "ubuntu" {
  compartment_id = oci_identity_compartment.isucon.id

  operating_system         = "Canonical Ubuntu"
  operating_system_version = "20.04"
  shape                    = var.instance_shape
  state                    = "AVAILABLE"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}
