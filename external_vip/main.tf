resource "openstack_networking_port_v2" "port_public" {
  name = "port_public"
  count = "${length(split(",", var.external_vips))}"
  network_id = "${var.network_id}"
  admin_state_up = "true"
  region = "${var.region}"
  fixed_ip = {
    ip_address = "${element(var.external_vips)}"
    subnet_id = "${var.subnet}" 
  }
}

resource "openstack_networking_floatingip_v2" "port_public_floating_ip" {
  count = "${length(split(",", var.external_vips))}"
  pool = "PublicNetwork"
  port_id = "${openstack_networking_port_v2.port_public.id}"
  region = "${var.region}"
}
