resource "openstack_blockstorage_volume_v2" "volume" {
  count = "${var.quantity}"
  name = "${var.name}"
  size = "${var.size}"
  volume_type = "${var.volume_type}"
  region = "${var.region}"
}

resource "openstack_compute_volume_attach_v2" "va" {
  count = "${var.quantity}"
  instance_id = "${element(var.instance, count.index)}"
  volume_id = "${element(openstack_blockstorage_volume_v2.volume.*.id, count.index)}"
  region = "${var.region}"
}
