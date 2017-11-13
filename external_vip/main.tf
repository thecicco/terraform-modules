resource "openstack_networking_port_v2" "port_public" {
  name = "port_public"
  count = "${length(split(",", var.external_vips))}"
  network_id = "${data.openstack_networking_network_v2.instance_network.id}"
  admin_state_up = "true"
  region = "${var.region}"
  fixed_ip = {
    ip_address = "${element(var.external_vips)}"
    subnet_id = "${var.subnet}" 
  }
}
