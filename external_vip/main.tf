resource "openstack_networking_port_v2" "port_public" {
  name = "port_public"
  count = "${length(var.external_vips)}"
  network_id = "${var.network_id}"
  admin_state_up = "true"
  region = "${var.region}"
  fixed_ip = {
    ip_address = "${element(var.external_vips, count.index)}"
    subnet_id = "${var.subnet}" 
  }
}

resource "openstack_networking_floatingip_v2" "port_public_floating_ip" {
  count = "${length(var.external_vips)}"
  pool = "PublicNetwork"
  port_id = "${element(openstack_networking_port_v2.port_public.*.id, count.index)}"
  region = "${var.region}"
}
