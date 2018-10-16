resource "openstack_compute_keypair_v2" "keypair" {
  name = "aickey"
  public_key = "${file(var.ssh_pubkey)}"
  region = "${var.region}"
}

output "name" {
  value = "${openstack_compute_keypair_v2.keypair.name}"
}
