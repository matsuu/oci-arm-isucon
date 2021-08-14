output "bench_public_ip" {
  value = oci_core_instance.bench.*.public_ip
}

output "competitor_public_ip" {
  value = oci_core_instance.competitor.*.public_ip
}

output "bench_private_ip" {
  value = oci_core_instance.bench.*.private_ip
}

output "competitor_private_ip" {
  value = oci_core_instance.competitor.*.private_ip
}
