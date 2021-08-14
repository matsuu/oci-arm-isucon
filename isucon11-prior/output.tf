output "webapp_public_ip" {
  value = oci_core_instance.webapp.*.public_ip
}
